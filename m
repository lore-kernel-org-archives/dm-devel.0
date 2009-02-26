From: "John A. Sullivan III" <jsullivan@opensourcedevel.com>
Subject: Re: multipathd segfault and error calling out
Date: Thu, 26 Feb 2009 00:14:10 -0500
Message-ID: <1235625250.6568.74.camel@jaspav.missionsit.net.missionsit.net>
References: <1235614064.6568.65.camel@jaspav.missionsit.net.missionsit.net>
	<20090226030401.GB6700@mars.virtualiron.com>
	<1235618628.6568.67.camel@jaspav.missionsit.net.missionsit.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1235618628.6568.67.camel@jaspav.missionsit.net.missionsit.net>
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

On Wed, 2009-02-25 at 22:23 -0500, John A. Sullivan III wrote:
> On Wed, 2009-02-25 at 22:04 -0500, Konrad Rzeszutek wrote:
> > On Wed, Feb 25, 2009 at 09:07:44PM -0500, John A. Sullivan III wrote:
> > > Hello, all.  I am running on kernel 2.6.27 on CentOS 5.2 with VServer
> > > and device-mapper-multipath-0.4.7-17.el5.  I have a custom
> > > mpath_prio_ssi script which takes the device name (e.g., sdaa), pulls
> > > out the path from /etc/disk/by-path and then echos a priority based upon
> > > a lookup table.  It works perfectly fine from the command line.
> > > multipath -ll shows the priorities assigned perfectly and exactly the
> > > right paths are active.
> > > 
> > > However, when I start multipathd, it all goes down the tubes.  The paths
> > > disappear and /var/log/messages is filled with:
> > > Feb 25 20:50:17 vd01 multipathd: error calling out /usr/local/sbin/mpath_prio_ssi sdh
> > 
> > Keep in mind that the environment you have when multipathd calls is quite
> > limited. I believe there is no PATH set, nor any other "normal" values.
> > 
> > Make sure your code uses absolute paths. So "/bin/grep" ,"/bin/cut", etc..
> <snip>
> Thank you.  I was enthusiastic that might have been the problem, but
> alas not. Even with absolute pathnames and setting the PATH variable, it
> still gives the same error.  In fact, I should have mentioned, I created
> a bogus file with the same pathname which did nothing but "echo hello"
> and it gave the same error calling out error.  What next? - John
This is increasingly bizarre.  I did an strace on the multipath command
and on the multipathd command.

Here is a portion of the strace for multipath:
close(1) = 0
dup(6)                               = 1
execve("/usr/local/sbin/mpath_prio_ssi", ["/usr/local/sbin/mpath_prio_ssi", "sda"], [/* 25 vars */]) = 0
brk(0)                                  = 0x8c3000

Here is the same call from multipathd:
close(1)                                = 0
dup(7)                                  = 1
execve("/usr/local/sbin/mpath_prio_ssi", ["/usr/local/sbin/mpath_prio_ssi", "sda"], [/* 25 vars */]) = -1 ENOENT (No such file or directory)
exit_group(-1)                          = ?

Is it my imagination or is it exactly the same call but one is finding
the file and the other is not.  What could cause this? It is an explicit
pathname and the file exists??!! Thanks - John
-- 
John A. Sullivan III
Open Source Development Corporation
+1 207-985-7880
jsullivan@opensourcedevel.com

http://www.spiritualoutreach.com
Making Christianity intelligible to secular society
