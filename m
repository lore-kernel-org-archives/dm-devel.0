From: "John A. Sullivan III" <jsullivan@opensourcedevel.com>
Subject: Re: Shell Scripts or Arbitrary Priority Callouts?
Date: Thu, 19 Mar 2009 07:04:37 -0400
Message-ID: <1237460677.6506.5.camel@jaspav.missionsit.net.missionsit.net>
References: <7bc80d500903181557x295480feia73d0c23992c6f65@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <7bc80d500903181557x295480feia73d0c23992c6f65@mail.gmail.com>
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

On Wed, 2009-03-18 at 15:57 -0700, Christopher Chen wrote:
> Hello, running Centos 5.2 here--
> 
> The multipathd daemon is very unhappy with any arbritrary script I
> provide for determining priorities. I see some fuzz in the syslog
> about ramfs and static binaries.
> 
> How do I use shell scripts or arbitrary programs for multipathd? I
> compiled a simple program that spits out "1" and it seems to return
> appropriately.
> 
> Also, why does multipath -ll return the appropriate data, namely
> prio=1 (when using my custom statically compiled callout) and
> multipath -l always returns prio=0? Is this an indication of a broken
> configuration or something else?
> 
> Cheers
> 
> cc
> 
I had the exact same problem and someone kindly explained it on this
list so thanks to them.

If I understand it correctly, multipathd must be prepared to function if
it loses access to disk.  Therefore, it is designed to not read from
disk but caches everything it needs in memory.  Apparently, it can only
cache binaries.

To use a shell script, call it via the shell, i.e., rather than
shell.script call sh shell.script.

That worked perfectly fine for me.  However, I do not know if multipathd
actually caches shell.script or if it still must read it from disk when
invoking sh and hence remains vulnerable to loss of disk access.  Does
anyone know? Thanks - John
-- 
John A. Sullivan III
Open Source Development Corporation
+1 207-985-7880
jsullivan@opensourcedevel.com

http://www.spiritualoutreach.com
Making Christianity intelligible to secular society
