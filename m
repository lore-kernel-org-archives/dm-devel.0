From: Gabriel de Perthuis <g2p.code@gmail.com>
Subject: Re: Chicken and egg problem with multipath-tools
Date: Sun, 3 Mar 2013 11:42:25 +0000 (UTC)
Message-ID: <kgvcv1$l3e$4@ger.gmane.org>
References: <1362220999.44153.YahooMailClassic@web126202.mail.ne1.yahoo.com>
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

> The problem is that multipathd wants to create a PID file under /var
> (which is at this time readonly). This fails and multipathd fails to
> start.

Distros handle this by putting pidfiles in /run, a tmpfs set up at early 
boot. There might be some magic to ensure that later mounts don't shadow 
it.
