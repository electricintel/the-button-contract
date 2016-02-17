contract TheButton {
    address owner; // or owners, can be set via multisig wallet contract
    address public winner;
    uint256 public deadline;
    uint256 minvalue;
    uint256 maxvalue;
    enum status {standby, started, ended}
        status Status;                                                                                            
        
    // Events, for show some info at Front End or create logs. 
    event TheButtonEnds(address winner, uint256 deadline);
    // [...]
    
    // Constructor
    function TheButton() {
        owner = msg.sender;
        minvalue = 10 finney; // 0.01 ether
        maxvalue = 1 ether;
    }
    
    // Any deposit to the contract address with or without data calls
    // to the non named function. 
    function () {
        // Start the game with the first deposit
        if ( Status == status.standby  && msg.value >= minvalue && msg.value <= maxvalue ){                           
            // The button game get started
            deadline = block.number + 20;
            winner = msg.sender;
            Status = status.started;
            return;
        } 
        else if (Status == status.started && now < deadline  && msg.value >= minvalue && msg.value <= maxvalue){
            deadline = block.number + 20;
            winner = msg.sender;    
            return;
        }
        else if ( Status == status.started && now >= deadline ){
            
            // [...]
            
            // Send all the current balance to winner.  
            winner.send(this.balance);
            Status = status.ended;
            // Event for detect when finished at front end
            TheButtonEnds(winner, deadline);
            return;
        }   

        // [...]


        // Return the deposit to the sender if: 
        //  - the game is ended.
        //  - the value of deposit is more than the maximun value.
        //  - the value of deposit is less than the minimun value.
        //  - [...]
        //  - The rest of causes.
        throw;
    }   
}
