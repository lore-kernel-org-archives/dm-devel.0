From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 05/16] Fix a couple of signal issues
Date: Fri, 03 May 2013 08:36:19 +0200
Message-ID: <51835AE3.7070604@acm.org>
References: <1367531197-8987-1-git-send-email-bmarzins@redhat.com>
	<1367531197-8987-6-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1367531197-8987-6-git-send-email-bmarzins@redhat.com>
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
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

On 05/02/13 23:46, Benjamin Marzinski wrote:
> The patch cleans up some signal issues.
> First, when the vecs locking around reconfigure got shuffled
> around earlier, it was removed from sighup. This patch restores
> that.
>
> Second, a new sigusr1 handler was created. However the existing
> one was never removed.  Since signal handlers are per-process, and
> not per-thread, the original handler will get overwritten by the
> new one, so this patch deletes the original handler.
>
> Third, sighup locks the vecs lock and sigusr1 locks logq_lock.
> However, these signals weren't being blocked before threads locked
> those locks.  This patch blocks those signals while those locks
> are being taken to avoid locking deadlocks.

Are you aware that POSIX does not allow any locking function to be 
invoked from inside a signal handler ? See e.g. 
http://pubs.opengroup.org/onlinepubs/9699919799/functions/V2_chap02.html#tag_15_04 
and the text that starts with "The following table defines a set of 
functions that shall be async-signal-safe. Therefore, applications can 
invoke them, without restriction, from signal-catching functions" for a 
list of C library functions that may be invoked from inside a signal 
handler.

Bart.
