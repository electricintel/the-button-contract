contract TheButton {
    address owner; // or owners, can be set via multisig wallet contract
    address public winner;
    address public gamer;
    uint256 public deadline;
    uint256 public short_wait;
    
    uint256 minvalue;
    uint256 maxvalue;
    enum status {standby, started, ended} status Status;                   
        
    // Events, for show some info at Front End or create logs. 
    event TheButtonEnds(address winner, uint256 deadline, uint timestamp);
    event TheButtonLog(address gamer, uint256 amount, uint timestamp);
    
    // Modifiers
    modifier onlyowner { 
        if (msg.sender != owner) throw;
        _
    }
    // Constructor
    function TheButton() {
        owner = msg.sender;
        minvalue = 10 finney; // 0.01 ether
        maxvalue = 1 ether;
        short_wait = 15;
    }
    
    // Call to change min/max values, only by the contract owner.
    function ChangeMaxMinValues(uint256 _minvalue, uint256 _maxvalue) onlyowner{
        minvalue = _minvalue;
        maxvalue = _maxvalue;
    }
    
    function SendWinnerPayout() private{
            winner = gamer;
             // Send all the current balance to winner.
            winner.send(this.balance);
            // Set contract to "ended" status.
            Status = status.ended;
            // Event for detect when finished
            TheButtonEnds(winner, deadline, block.number);
    }
    
    function NewGamer(address _gamer, uint256 amount) private{
        gamer = _gamer;
        deadline = block.number + short_wait ;
        TheButtonLog(gamer, amount , now);
    }
    
    // Check when the time ends, could be called by ethereum alarm clock
    function CheckExpired() returns (bool){
        bool expired = false;
        if ( Status == status.started && block.number >= deadline ){
            SendWinnerPayout();
            expired = true;
            return expired;
        }
        return expired;
    }
    
    function killContract() onlyowner{
        suicide(owner);
    }
    
    // Any deposit to the contract address without or with unknown data calls
    // to the non named function.
    function () {
        // Start the game with the first deposit
        if ( Status == status.standby  && msg.value >= minvalue && msg.value <= maxvalue ){                           
            // The button game get started
            NewGamer(msg.sender, msg.value);
            Status = status.started;
            return;
        }
        else if (Status == status.started && block.number < deadline  && msg.value >= minvalue && msg.value <= maxvalue){
            NewGamer(msg.sender, msg.value);   
            return;
        }
        else if ( Status == status.started && block.number >= deadline ){
            SendWinnerPayout();
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
