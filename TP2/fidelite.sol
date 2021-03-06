pragma solidity ^0.4.6;

// Abstract contract for the full ERC 20 Token standard
// https://github.com/ethereum/EIPs/issues/20
pragma solidity ^0.4.18;


contract EIP20Interface {
    /* This is a slight change to the ERC20 base standard.
    function totalSupply() constant returns (uint256 supply);
    is replaced with:
    uint256 public totalSupply;
    This automatically creates a getter function for the totalSupply.
    This is moved to the base contract since public getter functions are not
    currently recognised as an implementation of the matching abstract
    function by the compiler.
    */
    /// total amount of tokens
    uint256 public totalSupply;

    /// @param _owner The address from which the balance will be retrieved
    /// @return The balance
    function balanceOf(address _owner) public view returns (uint256 balance);

    /// @notice send `_value` token to `_to` from `msg.sender`
    /// @param _to The address of the recipient
    /// @param _value The amount of token to be transferred
    /// @return Whether the transfer was successful or not
    function transfer(address _to, uint256 _value) public returns (bool success);

    /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
    /// @param _from The address of the sender
    /// @param _to The address of the recipient
    /// @param _value The amount of token to be transferred
    /// @return Whether the transfer was successful or not
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);

    /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
    /// @param _spender The address of the account able to transfer the tokens
    /// @param _value The amount of tokens to be approved for transfer
    /// @return Whether the approval was successful or not
    function approve(address _spender, uint256 _value) public returns (bool success);

    /// @param _owner The address of the account owning tokens
    /// @param _spender The address of the account able to transfer the tokens
    /// @return Amount of remaining tokens allowed to spent
    function allowance(address _owner, address _spender) public view returns (uint256 remaining);

    // solhint-disable-next-line no-simple-event-func-name  
    event Transfer(address indexed _from, address indexed _to, uint256 _value); 
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}

/*
Implements EIP20 token standard: https://github.com/ethereum/EIPs/issues/20
.*/


contract EIP20 is EIP20Interface {

    uint256 constant private MAX_UINT256 = 2**256 - 1;
    mapping (address => uint256) public balances;
    mapping (address => mapping (address => uint256)) public allowed;
    /*
    NOTE:
    The following variables are OPTIONAL vanities. One does not have to include them.
    They allow one to customise the token contract & in no way influences the core functionality.
    Some wallets/interfaces might not even bother to look at this information.
    */
    string public name;                   //fancy name: eg Simon Bucks
    uint8 public decimals;                //How many decimals to show.
    string public symbol;                 //An identifier: eg SBX

    function EIP20(
        uint256 _initialAmount,
        string _tokenName,
        uint8 _decimalUnits,
        string _tokenSymbol
    ) public {
        balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
        totalSupply = _initialAmount;                        // Update total supply
        name = _tokenName;                                   // Set the name for display purposes
        decimals = _decimalUnits;                            // Amount of decimals for display purposes
        symbol = _tokenSymbol;                               // Set the symbol for display purposes
    }

    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(balances[msg.sender] >= _value);
        balances[msg.sender] -= _value;
        balances[_to] += _value;
        Transfer(msg.sender, _to, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        uint256 allowance = allowed[_from][msg.sender];
        require(balances[_from] >= _value && allowance >= _value);
        balances[_to] += _value;
        balances[_from] -= _value;
        if (allowance < MAX_UINT256) {
            allowed[_from][msg.sender] -= _value;
        }
        Transfer(_from, _to, _value);
        return true;
    }

    function balanceOf(address _owner) public view returns (uint256 balance) {
        return balances[_owner];
    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }   
}

contract Fidelity {

  //Client
  struct Client {
    string name;
    uint equity;
    string [] rewards;
    bool IsClient;
  }
  struct Reward {
    string reward;
    uint points;
    uint price;
  }

  //Commerçant
  address shop;
  mapping(address => Client)  public clients;
  Reward [] listReward;

  //Restriction
  modifier clientOwnly(){
      if (clients[msg.sender].IsClient) throw;
      _;
  }
  modifier shopOnly(){
    if (msg.sender != shop) throw;
    _;
  }

  //Constructeur
  function Fidelity(){
    shop = msg.sender;
    //SetClient(); //just in testRpc to test it
    //SetRewardList(); //just in testRpc to test it
  }

  function ConsultEquity(address asdresse) clientOwnly() constant returns (uint){
    return clients[asdresse].equity;
  }

  function CheckMyReward (address adresse, uint index) constant returns (string){
    return clients[adresse].rewards[index];
  }

  function CheckAllReward (address adresse, uint index) constant returns (string){
    return listReward[index].reward;
  }

  function ApplyReward (address adresse, uint pointSent) constant returns (bool){
    uint equity = clients[adresse].equity;
    uint rewardId = clients[adresse].rewards.length + 1;
    bool done = false;

    //check Balance
    if(pointSent < equity){
      for(uint i = 0; i < listReward.length; i++){
        if(pointSent == listReward[i].points){
          //add reward
          clients[adresse].rewards[rewardId] = listReward[i].reward;
          //delete point
          clients[adresse].equity -= pointSent;
          //set true
          done = true;
        }
      }
    }

    return done;
  }

  function Buy (uint price, address adresse) shopOnly() constant returns(string){
    string reward_proposition; //A déduire si le client le souhaite via Apply Reward

    for(uint i = 0; i < listReward.length; i++){
      if(listReward[i].price == price){
        clients[adresse].equity += listReward[i].points ; //Attribution des points en fonction du prix de l'achat
        reward_proposition = listReward[i].reward;
      }
    }
    return reward_proposition;
  }

}
