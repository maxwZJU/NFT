pragma solidity 0.8.9;

import '../node_modules/@openzeppelin/contracts/token/ERC721/ERC721.sol';

contract auction is ERC721 {
    
    struct Character {
        uint id;
        string name; //必要
        string imgurl;  //必要
        uint magic;  //附加功能
        uint strength;  //附加功能
        uint intelligence;  //附加功能
        uint luck;  //附加功能
        uint level;  //附加功能
        address[] ownerhistory;  //必要
        bool onsale;  //必要
        uint startprice;  //必要
        address [] bidderhistory;  //必要
        uint256[] bidpricehistory;  //必要
        bool setaside;  //必要
        uint endtime;  //必要
        
    }

    Character[] public characters;
    Character[] public result;
    Character[] public Demo;
    address[] public demo;
    address[] public temp;
    address public gameOwner;
    address public demoowner;

    constructor() ERC721("GameItem", "ITM") public {
        gameOwner = msg.sender;
    }

    function createNewCharacter(string memory _name,string memory _imgurl,uint _magic,uint _strength,uint _intelligence,uint _luck) payable public {
        require(msg.value == 0.1 ether);
        uint id = characters.length;
        delete temp;

        temp.push(msg.sender);
        address  [] memory temp3;
        uint [] memory temp2;
        characters.push(Character(id,_name,_imgurl,_magic,_strength,_intelligence,_luck, 1,temp,false,0,temp3,temp2,false,block.timestamp));
        _safeMint(msg.sender, id);
    }

    function getCharacter(address _sender) public returns(Character[] memory){
        delete result;
        for (uint i = 0; i < characters.length; i++) {
            if(ownerOf(i)==_sender){
                result.push(characters[i]);
            }
        }
        return result;
    }
    function getAuction() public returns(Character[] memory){
        delete result;
        for (uint256 i = 0; i < characters.length; i++) {
            if(characters[i].onsale==true){
                result.push(characters[i]);
            }
        }
        return result;
    }
    function createNewAuction(uint _id,uint _sec,uint256 _startprice) payable public{
        require(msg.value == 0.1 ether);
        require(msg.sender==ownerOf(_id));
        require(characters[_id].onsale==false);
        require(characters[_id].setaside==false);
        characters[_id].onsale=true;
        characters[_id].endtime=block.timestamp+_sec;
        characters[_id].startprice=_startprice;
    }

    function refreshAllAuction() payable public returns(uint256){
        checkAllOverTime(block.timestamp);
        for(uint i=0;i<characters.length;i++){
            if(characters[i].onsale==true){
                if(characters[i].endtime<=block.timestamp){
                    characters[i].onsale=false;
                    characters[i].setaside=true;
                }
            }
                    
                
        }
        return block.timestamp;
    }
    function checkAllOverTime(uint timestamp)payable public{
        for(uint i=0;i<characters.length;i++){
            if(characters[i].setaside==true){
                if(timestamp>=characters[i].endtime+10*24*3600){
                    uint index=characters[i].bidderhistory.length;
                    if(index==0){
                        delete characters[i].bidderhistory;
                        delete characters[i].bidpricehistory;
                        characters[i].setaside=false;
                    }
                    else{
                        index=index-1;
                        address buyer=characters[i].bidderhistory[index];
                        approve(buyer,i);
                        uint256 money=characters[i].bidpricehistory[index];
                        address payable owner=payable(msg.sender);
                        owner.transfer(money);
                        delete characters[i].bidderhistory;
                        delete characters[i].bidpricehistory;
                        characters[i].setaside=false;
                    }
                }
            }
        }
    }
    function ownerconfirm(uint _id)payable public{
        require(characters[_id].setaside==true);
        uint once = 0;
        once = once + 1;
        require(msg.sender==ownerOf(_id));
        uint index=characters[_id].bidderhistory.length;
        if(index==0){
            delete characters[_id].bidderhistory;
            delete characters[_id].bidpricehistory;
            characters[_id].setaside=false;
        }
        else{
            index=index-1;
            require(index>=0);
            address buyer=characters[_id].bidderhistory[index];
            approve(buyer,_id);
            uint256 money=characters[_id].bidpricehistory[index];
            address payable owner=payable(msg.sender);
            uint256 money1=money*90/10000;
            uint256 money2=(money-money1)*1/100;
            owner.transfer(money1);
            payable(gameOwner).transfer(money2);
        }
    }
    function buyerconfirm(uint _id)payable public{
        require(characters[_id].setaside==true);
        require(msg.sender !=ownerOf(_id));
        transferFrom(ownerOf(_id),msg.sender, _id);
        characters[_id].setaside=false;
        delete characters[_id].bidpricehistory;
        characters[_id].ownerhistory.push(msg.sender);
        delete characters[_id].bidderhistory;
    }
    function bid(uint256 _id, address sender)payable public{
        require(msg.sender !=ownerOf(_id));
        require(characters[_id].onsale=true);
        if(characters[_id].bidderhistory.length==0){
            characters[_id].bidderhistory.push(msg.sender);
            characters[_id].bidpricehistory.push(100*msg.value/1000000000000000000);
        }
        else{
            uint once = 0;
            once = once + 1;
            uint index=characters[_id].bidderhistory.length;
            index=index-1;
            payable(characters[_id].bidderhistory[index]).transfer(characters[_id].bidpricehistory[index]);
            characters[_id].bidderhistory.push(msg.sender);
            characters[_id].bidpricehistory.push(100*msg.value/1000000000000000000);
        }
    }

    function getbid(address _sender) public returns(Character[] memory){
        delete result;
        for(uint i=0;i<characters.length;i++){
            if(characters[i].onsale==true||characters[i].setaside==true)
            for(uint j=0;j<characters[i].bidderhistory.length;j++){
                if(characters[i].bidderhistory[j]==_sender){
                    result.push(characters[i]);
                    uint once = 0;
                    once = once + 1;
                    break;
                }
            }
        }
        return result;
    }
}