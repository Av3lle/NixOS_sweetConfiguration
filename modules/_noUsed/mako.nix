{ ... }:
{
  services.mako = {
    enable = false;
    settings = {
      font="JetBrainsMono 10";
      format="<span size='11pt'><b>%a ⏵ </b></span> %s %b";
      sort="+time";
      layer="top";
      anchor="top-right";
      backgroundColor="#242323";
      width=330;
      height=110;
      margin="5,5,15";
      # margin="15,15,15";
      padding="0,5,10";
      borderSize=2;
      borderColor="#FFFFFF";
      borderRadius=15;
      icons=true;
      maxIconSize=55;
      defaultTimeout=120000;
      maxVisible=3;
    };
  };
}
