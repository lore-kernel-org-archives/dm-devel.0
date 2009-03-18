From: Christopher Chen <muffaleta@gmail.com>
Subject: Shell Scripts or Arbitrary Priority Callouts?
Date: Wed, 18 Mar 2009 15:57:48 -0700
Message-ID: <7bc80d500903181557x295480feia73d0c23992c6f65@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
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

Hello, running Centos 5.2 here--

The multipathd daemon is very unhappy with any arbritrary script I
provide for determining priorities. I see some fuzz in the syslog
about ramfs and static binaries.

How do I use shell scripts or arbitrary programs for multipathd? I
compiled a simple program that spits out "1" and it seems to return
appropriately.

Also, why does multipath -ll return the appropriate data, namely
prio=1 (when using my custom statically compiled callout) and
multipath -l always returns prio=0? Is this an indication of a broken
configuration or something else?

Cheers

cc

-- 
Chris Chen <muffaleta@gmail.com>
"I want the kind of six pack you can't drink."
-- Micah
