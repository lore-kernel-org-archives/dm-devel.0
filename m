From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v2 0/3] dm: allow mempool and bioset reserves
	to be tuned
Date: Fri, 13 Sep 2013 15:22:20 -0400
Message-ID: <20130913192220.GA8120@redhat.com>
References: <1379024698-10487-1-git-send-email-snitzer@redhat.com>
	<1379098780-15141-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1379098780-15141-1-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Frank Mayhar <fmayhar@google.com>, Mikulas Patocka <mpatocka@redhat.com>
Cc: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Fri, Sep 13 2013 at  2:59pm -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> You can pull these changes from the 'devel' branch of:
> git://git.kernel.org/pub/scm/linux/kernel/git/snitzer/linux.git
> 
> To browse, see:
> https://git.kernel.org/cgit/linux/kernel/git/snitzer/linux.git/log/?h=devel
> 
> v2 changes:
> Simplified the implementation.  Dropped the peak_reserved_rq_based_ios
> tracking, we'll use the tracepoint patch Jun'ichi Nomura suggested:
> http://www.redhat.com/archives/dm-devel/2013-September/msg00048.html

This needs a v3 because the simplified code doesn't handle bounds
properly (previous version handled remapping 0 to defaults).  But we
also need a maximum value that we're willing to support.  So if the user
exceeds that value it is reset to the max supported.
