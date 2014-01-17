From: Nicolas Michel <be.nicolas.michel@gmail.com>
Subject: Show pathgroup informations with multipathd -k?
Date: Fri, 17 Jan 2014 13:53:55 +0100
Message-ID: <CAO5znatFLXF=Dico2VwMgGQrhMvEwoeKc1fD9mDgkmL2dEgDOw@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi again,

I have another question for which I don't find any answer from
documentation/man and on the net. I want to display the algorithm used
by a multipath device (the "policy" as seen in multipath -ll). When
doing a "show wildcards" in the multipathd shell, I can see there are
wildcards for the "pathgroup" (last block):

multipathd> show wildcards
multipath format wildcards:
%n  name
%w  uuid
%d  sysfs
%F  failback
%Q  queueing
%N  paths
%r  write_prot
%t  dm-st
%S  size
%f  features
%h  hwhandler
%A  action
%0  path_faults
%1  switch_grp
%2  map_loads
%3  total_q_time
%4  q_timeouts
%s  vend/prod/rev

path format wildcards:
%w  uuid
%i  hcil
%d  dev
%D  dev_t
%t  dm_st
%o  dev_st
%T  chk_st
%s  vend/prod/rev
%c  checker
%C  next_check
%p  pri
%S  size

pathgroup format wildcards:
%s  selector
%p  pri
%t  dm_st


But a "help" command doesn't document any "pathgroup" target for a
show command :

multipathd> help
multipath-tools v0.4.9 (04/04, 2009)
CLI commands reference:
 list|show paths
 list|show paths format $format
 list|show status
 list|show daemon
 list|show maps|multipaths
 list|show maps|multipaths status
 list|show maps|multipaths stats
 list|show maps|multipaths format $format
 list|show maps|multipaths topology
 list|show topology
 list|show map|multipath $map topology
 list|show config
 list|show blacklist
 list|show devices
 list|show wildcards
 add path $path
 remove|del path $path
 add map|multipath $map
 remove|del map|multipath $map
 switch|switchgroup map|multipath $map group $group
 reconfigure
 suspend map|multipath $map
 resume map|multipath $map
 resize map|multipath $map
 disablequeueing map|multipath $map
 restorequeueing map|multipath $map
 disablequeueing maps|multipaths
 restorequeueing maps|multipaths
 reinstate path $path
 fail path $path
 paths count
 forcequeueing daemon
 restorequeueing daemon
 quit|exit
 map|multipath $map getprstatus
 map|multipath $map setprstatus
 map|multipath $map unsetprstatus

So I don't know from multipathd -k how to get the policy of a multipath device.

It would be really great if someone could explain it ;)

Thanks a lot,

-- 
Nicolas MICHEL
