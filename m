From: "David Strand" <dpstrand@gmail.com>
Subject: Re: multibus / failover and EMC CX600
Date: Fri, 19 Oct 2007 15:35:38 -0700
Message-ID: <448b15030710191535j472f2e40pfda6ff1c8d0b1327@mail.gmail.com>
References: <066001c810cc$cd9f6f90$0a00a8c0@ALDI2>
	<20071018061907.GA22562@pentland.suse.de>
	<06cf01c81153$eca36c70$0a00a8c0@ALDI2>
	<20071018071244.GB22562@pentland.suse.de>
	<06e001c8115d$ffd7e9b0$0a00a8c0@ALDI2>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <06e001c8115d$ffd7e9b0$0a00a8c0@ALDI2>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

I have this same -EEXIST problem.

If the /dev/mapper/mpath* device node is mounted with a file sys when
the disk is disconnected, multipath won't give up one of the device
paths (logs "map in use"). If the disk is then reconnected it will get
a new scsi device name. Now multipath is sometimes confused (shows 3
paths, one of which is ####), and sometimes I get the -EEXIST core
dump to go along with it.

I can do the same disconnect / reconnect of the disk all day long, as
long as no file system is mounted on it. Of course, there will pretty
much always be a file system mounted on it so that isn't really a
solution, just a fact.
