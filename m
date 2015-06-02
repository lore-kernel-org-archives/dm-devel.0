From: Christian Seiler <christian@iwakd.de>
Subject: Re: [PATCH] libmultipath: don't lock block device but
 use lock files
Date: Tue, 02 Jun 2015 14:09:24 +0200
Message-ID: <4aa67d7fdb957d8dd2ef5ab3c84c6376@iwakd.de>
References: <5560EA5C.6040001@iwakd.de> <556178AC.2010501@suse.de>
	<5561863B.5020001@iwakd.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <5561863B.5020001@iwakd.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

Am 2015-05-24 10:05, schrieb Christian Seiler:
> That said, I've noticed that my patch might cause multipathd to have
> the lock file fds open unnecessarily, so I've updated it to close 
> them
> on regular unlocking (but not on failure, because that means there 
> will
> be a retry). Version 2 is attached.

Ping?

Christian
