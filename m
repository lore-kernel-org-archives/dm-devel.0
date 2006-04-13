From: Fraser Campbell <fraser@georgetown.wehave.net>
Subject: multipath selection based on queue length
Date: Thu, 13 Apr 2006 16:23:57 -0400
Message-ID: <443EB35D.5050808@georgetown.wehave.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

Hi,

Our SAN group would like us to balance I/O requests across all paths 
based on queue length.  My understanding of this is that we would 
essentially route each I/O request down the path with fewest pending I/O 
requests (perhaps my understanding is overly simplistic).

Is this possible with dm-multipath, multipath-tools, etc?  I am running 
SLES 9 which includes dm-multipath 1.0.4 and multipath-tools 0.4.5.

The SAN is a Hitachi Tagma, here is one test LUN:

   350060e80000000000000a95200000480
   [size=13 GB][features="0"][hwhandler="0"]
   \_ round-robin 0 [enabled][best]
     \_ 0:0:0:36 sde  8:64    [active]
   \_ round-robin 0 [enabled]
     \_ 1:0:0:36 sdj  8:144   [active]

That is default config, I have also setup with multibus but our SAN 
group does not want us to use round-robin load balancing, nor do they 
want us to use single-path I/O as we would get with the failover approach.

Any suggestions?

Thanks,
Fraser
