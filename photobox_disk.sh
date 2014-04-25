
fdisk /dev/sdb

delete all 
n : add new partition

mkfs.ext4 -j -L varlib -O dir_index -m 2 -J size=400 -b 4096 -R stride=16 /dev/sdb1


blkid /dev/sdb1


"b11b368c-b305-4f4f-95a4-5e3c8cad63ae"


 # /var/lib is on sdb1 ! (RAID 10)
 UUID=b11b368c-b305-4f4f-95a4-5e3c8cad63ae /var/lib        ext4    rw,noatime,nodiratime,nobarrier,data=ordered 0 1
