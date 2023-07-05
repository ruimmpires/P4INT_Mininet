-- Return a slice of a table
function table_slice(input_table, first, last)
  local subtable = {}
  for i = first, last do
    subtable[#subtable + 1] = input_table[i]
  end
  return subtable
end

-- Convert a number to bits
function tobits(number, bitcount, first_bit, last_bit)
    local bit_table = {}
    for bit_index = bitcount, 1, -1 do
        remainder = math.fmod(number, 2)
        bit_table[bit_index] = remainder
       number = (number - remainder) / 2
    end
    return table.concat(table_slice(bit_table, first_bit, last_bit))
end

p4_proto = Proto("p4-int_report_RPires","P4-INT_REPORT Protocol")
p4_int_proto = Proto("p4-int_header", "P4-INT_HEADER Protocol")

function p4_proto.dissector(buffer,pinfo,tree)
    pinfo.cols.protocol = "P4-INT REPORT"
    local subtree_report = tree:add(p4_proto,buffer(),"Telemetry Report")
    subtree_report:add(buffer(0,1), "ver (4 bits) - Binary: " .. tobits(buffer(0,1):uint(), 8, 1, 4))
    --subtree_report:add(buffer(0,1), "hw_id (6 bits) - Binary: " .. tobits(buffer(0,1):uint(), 8, 3, 8))
    --subtree_report:add(buffer(2,4), "seq_no (22 bits) - Hex: " .. string.format("%08X", buffer(2,4):bitfield(0, 22)))
    --subtree_report:add(buffer(3,1), "node_id (32 bits) - Binary: " .. tobits(buffer(3,1):uint(), 8, 3, 32))




    --subtree_report:add(buffer(0,1), "nproto (4 bits) - Binary: " .. tobits(buffer(0,1):uint(), 8, 5, 8))
    --subtree_report:add(buffer(1,1), "d (1 bits) - Binary: " .. tobits(buffer(1,1):uint(), 8, 1, 1))
    --subtree_report:add(buffer(1,1), "q (1 bits) - Binary: " .. tobits(buffer(1,1):uint(), 8, 2, 2))
    --subtree_report:add(buffer(1,1), "f (1 bits) - Binary: " .. tobits(buffer(1,1):uint(), 8, 3, 3))
    --subtree_report:add(buffer(1,3), "rsvd (15 bits) - Hex: " .. string.format("%04X", buffer(1,3):bitfield(4, 18)))
    --subtree_report:add(buffer(8,4), "ingress_tstamp (32 bits) - Hex: " .. string.format("%08X", buffer(8,4):bitfield(0, 32)))


    subtree_report:add(buffer(46,4), "src_addr (32 bits) - " .. string.format("%d.%d.%d.%d",
                                                                buffer(46,1):bitfield(0, 8), buffer(47,1):bitfield(0, 8),
                                                                buffer(48,1):bitfield(0, 8), buffer(49,1):bitfield(0, 8)))
    subtree_report:add(buffer(50,4), "dst_addr (32 bits) - " .. string.format("%d.%d.%d.%d",
                                                                buffer(50,1):bitfield(0, 8), buffer(51,1):bitfield(0, 8),
                                                                buffer(52,1):bitfield(0, 8), buffer(53,1):bitfield(0, 8)))

 
    subtree_report:add(buffer(54,2), "src_port (16 bits) - " .. string.format("%d", buffer(54,2):bitfield(0, 16)))
    subtree_report:add(buffer(56,2), "dst_port (16 bits) - " .. string.format("%d", buffer(56,2):bitfield(0, 16)))
     
    --subtree_report:add(buffer(58,2), "ip_proto (16 bits) - " .. string.format("%d", buffer(58,2):bitfield(0, 16)))
   
    subtree_report:add(buffer(80,2), "Hop3 switch ID (16 bits) - - - - - - - - " .. string.format("%d", buffer(80,2):bitfield(0, 16)))
    subtree_report:add(buffer(82,2), "Hop3 l1 ingress port (16 bits) - " .. string.format("%d", buffer(82,2):bitfield(0, 16)))
    subtree_report:add(buffer(84,2), "Hop3 l1 egress port (16 bits) - " .. string.format("%d", buffer(84,2):bitfield(0, 16)))
    subtree_report:add(buffer(88,2), "Hop3 latency (16 bits) - " .. string.format("%d", buffer(88,2):bitfield(0, 16)))
    subtree_report:add(buffer(92,2), "Hop1 queue size (16 bits) - " .. string.format("%d", buffer(92,2):bitfield(0, 16)))
    subtree_report:add(buffer(112,2), "Hop1 l2 ingress port (16 bits) - " .. string.format("%d", buffer(112,2):bitfield(0, 16)))
    subtree_report:add(buffer(116,2), "Hop1 l2 egress port (16 bits) - " .. string.format("%d", buffer(116,2):bitfield(0, 16)))


    subtree_report:add(buffer(124,2), "Hop2 switch ID (16 bits) - - - - - - - - " .. string.format("%d", buffer(124,2):bitfield(0, 16)))
    subtree_report:add(buffer(126,2), "Hop2 l1 ingress port (16 bits) - " .. string.format("%d", buffer(126,2):bitfield(0, 16)))
    subtree_report:add(buffer(128,2), "Hop2 l1 egress port (16 bits) - " .. string.format("%d", buffer(128,2):bitfield(0, 16)))
    subtree_report:add(buffer(132,2), "Hop2 latency (16 bits) - " .. string.format("%d", buffer(132,2):bitfield(0, 16)))
    subtree_report:add(buffer(136,2), "Hop1 queue size (16 bits) - " .. string.format("%d", buffer(136,2):bitfield(0, 16)))
    subtree_report:add(buffer(156,2), "Hop1 l2 ingress port (16 bits) - " .. string.format("%d", buffer(156,2):bitfield(0, 16)))
    subtree_report:add(buffer(160,2), "Hop1 l2 egress port (16 bits) - " .. string.format("%d", buffer(160,2):bitfield(0, 16)))


    subtree_report:add(buffer(168,2), "Hop1 switch ID (16 bits) - - - - - - - - " .. string.format("%d", buffer(168,2):bitfield(0, 16)))
    subtree_report:add(buffer(170,2), "Hop1 l1 ingress port (16 bits) - " .. string.format("%d", buffer(170,2):bitfield(0, 16)))
    subtree_report:add(buffer(172,2), "Hop1 l1 egress port (16 bits) - " .. string.format("%d", buffer(172,2):bitfield(0, 16)))
    subtree_report:add(buffer(176,2), "Hop1 latency (16 bits) - " .. string.format("%d", buffer(176,2):bitfield(0, 16)))
    subtree_report:add(buffer(180,2), "Hop1 queue size (16 bits) - " .. string.format("%d", buffer(180,2):bitfield(0, 16)))
    subtree_report:add(buffer(200,2), "Hop1 l2 ingress port (16 bits) - " .. string.format("%d", buffer(200,2):bitfield(0, 16)))
    subtree_report:add(buffer(204,2), "Hop1 l2 egress port (16 bits) - " .. string.format("%d", buffer(204,2):bitfield(0, 16)))
  end

my_table = DissectorTable.get("udp.port")
my_table:add(1234, p4_proto)
