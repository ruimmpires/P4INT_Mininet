import argparse
from p4utils.mininetlib.network_API import NetworkAPI, Node, info
#from mininet.util import runCmd
from mininet.link import TCLink

default_rule = 'tables/'

def config_network(p4):
    net = NetworkAPI()

    # Network general options
    net.setLogLevel('info')
    net.enableCli()

    # Network definition
    net.addP4Switch('s1',cli_input= default_rule + 's1-commands.txt')
    net.addP4Switch('s2',cli_input= default_rule + 's2-commands.txt')
    net.addP4Switch('s3',cli_input= default_rule + 's3-commands.txt')
    net.addP4Switch('s4',cli_input= default_rule + 's4-commands.txt')
    net.addP4Switch('s5',cli_input= default_rule + 's5-commands.txt')
    #net.addSwitch('s6')

    net.setP4SourceAll(p4)

    h1=net.addHost('h1') #source traffic
    h2=net.addHost('h2') #server at 8080
    h3=net.addHost('h3') #source traffic
    h4=net.addHost('h4') #INTcollector
    h5=net.addHost('h5') #ROGUE host

    net.addLink('h1', 's1')
    net.addLink('h2', 's3')
    net.addLink('h3', 's5')
    net.addLink('s1', 's2')
    net.addLink('s2', 's3')
    net.addLink('s1', 's4')
    net.addLink('s2', 's5')
    net.addLink('s4', 's5', cls=TCLink,bw=0.1)
    net.addLink('s4', 's3', cls=TCLink,bw=0.1)
    

    net.addLink('h4', 's3')
    net.addLink('h5', 's3')
    
    #net.addLink('s3', 's6')
    #net.addLink('h3', 's6')
    #net.addLink('h4', 's6')    

    # Assignment strategy
    net.mixed()

    # Nodes general options
    #net.enableCpuPortAll()
    #net.enablePcapDumpAll()
    net.enableLogAll()
    
    
    #start a listener in h2
    #runCmd(h2, 'while tru; do nc -ul -p80 -w0 &;done')
    #info ('h2 listens to udp on port 80\n')
    #Node(h2).cmd('while tru; do nc -ul -p80 -w0 &;done')
    
    #send data from h1 and h3
    #Node(h1).cmd('watch -n5 python3 send.py --ip 10.0.3.2 --l4 udp --port 80 --m INTH1 --c1 &')
    #info ('h1 sending data to h2:8080\n')
    #Node(h3).cmd('watch -n60 python3 send.py --ip 10.0.3.2 --l4 udp --port 8080 --m INTH3 --c1')
    #info ('h3 sending data to h2:8080\n')	
    #info ('run in your host computer: sudo python3 report_collector/collector_influxdb.py\n')

    return net


def get_args():
    parser = argparse.ArgumentParser()
    parser.add_argument('--p4', help='p4 src file.',
                        type=str, required=False, default='p4src/intv8.p4')
                        
    return parser.parse_args()


def main():
    args = get_args()
    net = config_network(args.p4)
    net.startNetwork()

    
    
if __name__ == '__main__':
    main()
