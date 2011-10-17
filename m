From: Joe Thornber <thornber@redhat.com>
Subject: Re: [PATCH] dm-bufio
Date: Mon, 17 Oct 2011 12:14:43 +0100
Message-ID: <20111017111442.GG13963@ubuntu>
References: <Pine.LNX.4.64.1110141500160.29246@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1110141500160.29246@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com, Mike Snitzer <msnitzer@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Fri, Oct 14, 2011 at 03:14:34PM -0400, Mikulas Patocka wrote:
@@ -999,15 +1013,19 @@ again:
                 * someone is doing some writes simultaneously with us --- in
                 * this case, stop dropping the lock.
                 */
                if (dropped_lock)
                        goto again;
        }
        wake_up(&c->free_buffer_wait);
        dm_bufio_unlock(c);

-       a = xchg(&c->async_write_error, 0);
+       if (likely(!c->async_write_error))
+               a = 0;
+       else
+               a = xchg(&c->async_write_error, 0);
        f = dm_bufio_issue_flush(c);


I didn't change this.  Is it also fixing a preexisting issue?
