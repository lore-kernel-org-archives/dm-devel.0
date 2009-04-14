From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [RFC] dm snapshot based asynchronous replication
Date: Tue, 14 Apr 2009 12:29:01 +0900
Message-ID: <20090414122812K.fujita.tomonori@lab.ntt.co.jp>
References: <1567864196.1766411239656669717.JavaMail.root@zimbra16-e3.priv.proxad.net>
	<177494415.1766861239656900680.JavaMail.root@zimbra16-e3.priv.proxad.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <177494415.1766861239656900680.JavaMail.root@zimbra16-e3.priv.proxad.net>
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

On Mon, 13 Apr 2009 23:08:20 +0200 (CEST)
christophe.varoqui@free.fr wrote:

> dm developers,
> 
> I'm in need of an asynchronous replication method for active/passive clusters using direct-attached disks. Please advise if you know tools (other than drdb an rsync) to do the job. (How goes dm-replicator btw ?).

Zumastor?

http://zumastor.org/

An asynchronous remote replication based on snapshots is one of
reasons why I worked a new dm snapshot implementation:

https://www.redhat.com/archives/dm-devel/2008-August/msg00003.html


Jonathan Brassow has been working on it (Jonathan, Thanks!):

http://marc.info/?l=dm-devel&m=123905441719141&w=2

If you add the interface to get the delta between two snapshots, then
you can implement a daemon in user space that does an asynchronous
remote replication.
