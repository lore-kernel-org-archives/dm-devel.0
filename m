From: "Andrei B." <andrixnet@yahoo.com>
Subject: Chicken and egg problem with multipath-tools
Date: Sat, 2 Mar 2013 02:43:19 -0800 (PST)
Message-ID: <1362220999.44153.YahooMailClassic@web126202.mail.ne1.yahoo.com>
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

Hi, 

I've been trying to install multipath-tools on a couple of linux servers with FC storage that I work with. 
They run Linux Slackware.
I've built from source, created an installable package (Slackware style) and deployed it. 

I have discovered the following problem (chicken and egg style):

- multipathd, AFAIK, should start before LVM, because if several volumes need be assembled by LVM, they should exist before LVM starts. 
- multipathd, AFAIK, should start before any service that has it's data stored on the remote storage. 

I am not familiar [enough] with the inner workings of the startup sequence on redhat/debian like systems. 
Slackware's startup sequence is much simpler and I placed multipathd in file rc.S (which is the first one called by init) right before LVM. 

And here lies the chicken-egg problem. At this point, only the root filesystem is mounted and it is mounted read-only. It is the correct and proper startup sequence in Slackware. Filesystems are checked for errors after LVM starts and then root is remounted read-write and the rest of the filesystems are mounted. 

The problem is that multipathd wants to create a PID file under /var (which is at this time readonly). This fails and multipathd fails to start. 
It took me a lot of testing and reboots until I managed to determine this is the actual problem.

The stop-gap solution I have found, so far, is to load dm-multipath module and run multipath -v0 before LVM, thus creating the multipath devices, then later, after the filesystems are remounted rw, start multipathd. 

Can you suggest a better way of doing this, so that the system can do multipath management during the startup sequence and filesystem checks, from the creation of the devices to the starting of multipathd later ? 

Thank you. 
