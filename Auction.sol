pragma solidity >=0.7.0 <0.9.0;
contract Openauction {
    
    //Declarations of the variables
    address owner;
    address payable public beneficiary;
    uint256 startTime;
    address public highestBidder;
    uint public highestBid;
    uint public auctionEndTime;
    bool ended;
    
    modifier onlyOwner() {
        require(msg.sender == owner,"This function is only be called by owner of this contract only");
        _;
    }
    
      modifier onlyWhileOpen1() {
        require(block.timestamp >= startTime,"Auction has not being started yet");
        _;
    }
    
    modifier onlyWhileOpen2() {
        require(!ended, "Auction has been ended!!!Bye Bye have a good day ahead...");
        _;
    }
    
    
    //Creation of the mapping
    mapping(address => uint) pending_returns;

   //Creation of the event
    event HighestBidIncreased(address bidder, uint amount);
    event AuctionEnded(address winner, uint amount);

    //Creation of the constructor
    constructor(uint _auctionDuration,address payable _beneficiary) {
        owner = msg.sender;
        beneficiary = _beneficiary;
        startTime=1617694990;
        auctionEndTime=_auctionDuration;
       }
    
   //Defining of the function
    function bid() public payable onlyWhileOpen1 onlyWhileOpen2{
        
        //Require condition
        require(msg.value > highestBid,"There is already a higher bid !!! Please bid higher than preivous bid");

        //If-else condition
        if (highestBid != 0) {
            
            pending_returns[highestBidder] += highestBid;
            
        }
        highestBidder = msg.sender;
        highestBid = msg.value;
        
        //Emittion of the event
        emit HighestBidIncreased(msg.sender, msg.value);
    }

    //Defining of the function
    function withdraw() public returns (bool) {
        uint amount = pending_returns[msg.sender];
        
        //If-else condition
        if (amount > 0) {
           
            pending_returns[msg.sender] = 0;

            if (!payable(msg.sender).send(amount)) {
                
                pending_returns[msg.sender] = amount;
                return false;
            }
        }
        return true;
    }

    //Defining of the function
    function auctionend() public onlyWhileOpen1 onlyWhileOpen2 onlyOwner{
       

        //Require condition
        require(!ended, "auctionEnd function has been already called");

    
        ended = true;
        emit AuctionEnded(highestBidder, highestBid);

        beneficiary.transfer(highestBid);
    }
}