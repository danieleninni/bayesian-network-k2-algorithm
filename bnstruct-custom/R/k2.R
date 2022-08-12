################################################################################
#  Advanced Statistics for Physical Analysis // University of Padua, AY 2021/22
#  Group: Barone Nagaro Ninni
#
#    K2 algorithm implementation in bnstruct
#
#  last edit: 17 July 2022
#-------------------------------------------------------------------------------
#  under GPL-3.0 licence
#-------------------------------------------------------------------------------

library(tidyverse)

log.f <- function(node, parents, dataset) {

    node.nunique <- dataset[node] |>
                        unique() |>
                        nrow()

    contingency_table <- dataset[c(node, parents)] |>
                            table() |>
                            as.data.frame() |>
                            as_tibble() |>
                            filter(Freq > 0)

    A <- 1:(node.nunique - 1) |>
            log() |>
            sum()

    B <- contingency_table |>
            rowwise() |>
            mutate(Freq = ((1:Freq) |> log() |> sum())) |>
            ungroup() |>
            group_by_at(parents) |>
            summarise(Freq = sum(Freq), .groups='drop_last') |>
            ungroup() |>
            select(Freq) |>
            deframe()

    C <- contingency_table |>
            group_by_at(parents) |>
            summarise(Freq = sum(Freq), .groups='drop_last') |>
            ungroup() |>
            rowwise() |>
            mutate(Freq = ((1:(Freq + node.nunique - 1)) |> log() |> sum())) |>
            ungroup() |>
            select(Freq) |>
            deframe()

    dataset.log.prob <- sum(A + B - C)
    
    return(dataset.log.prob)

}


k2 <- function(dataset, parents.nmax, f = log.f) {
        
        #####################
        ##  PREPROCESSING  ##
        #####################
        
        # Since bnstruct uses custom objects, we do some stuff to use
        #  our function in this environment.
        nodes <- names(dataset)
        n <- length(nodes)
        
        # creating a named vector to select the correct index in dag matrix
        candidate.idx <- 1:n
        names(candidate.idx) <- nodes
        
        # allocating an empty adjacency matrix of the network  (see AllClasses.R)
        adjm <- matrix(0, n, n)
        
        
        
        ####################
        ##  K2 ALGORITHM  ##
        ####################

        for (i in 2:length(nodes)) {

            node           <- nodes[i]                  # current node
            previous.nodes <- nodes[1:(i-1)]            # nodes that precede the current node
            parents        <- c()                       # parents of the current node
            P_old          <- f(node, parents, dataset) # old probability
            proceed        <- T
            
            while (proceed & (length(parents) < parents.nmax)) {

                candidates <- setdiff(previous.nodes, parents) # candidate parents of the current node 
                P_new      <- P_old                            # new probability

                for (candidate in candidates) {

                    candidate.score <- f(node, c(parents, candidate), dataset) # candidate parent score

                    if (candidate.score > P_new) {

                        candidates.best <- candidate       # best candidate parent
                        P_new           <- candidate.score

                    }

                }

                if (P_new > P_old) {

                    P_old   <- P_new
                    parents <- c(parents, candidates.best)
                    #net.dag <- set.arc(net.dag, from=candidates.best, to=node)
                    adjm[ candidate.idx[candidates.best], i] <- 1  # set the arc

                } else {

                    proceed <- F

                }

            }

        }
        
	return(adjm)
}
