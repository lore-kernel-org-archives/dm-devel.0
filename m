From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 16/24] dm cache: log error message
	if	dm_kcopyd_copy() fails
Date: Fri, 8 Nov 2013 13:33:11 +0000
Message-ID: <20131108133311.GA3876@agk-dp.fab.redhat.com>
References: <1382639437-27007-1-git-send-email-snitzer@redhat.com>
	<1382639437-27007-17-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1382639437-27007-17-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: Morgan Mears <morgan.mears@netapp.com>, Heinz Mauelshagen <heinzm@redhat.com>, dm-devel@redhat.com, Joe Thornber <ejt@redhat.com>
List-Id: dm-devel.ids

On Thu, Oct 24, 2013 at 02:30:29PM -0400, Mike Snitzer wrote:
> A migration failure should be logged (albeit limited).
 
Does this *really* add anything useful?

migration_failure() already always logs a message, so you'll now get
two (throttled) messages instead of one every time.

Would it be better to log not just the type of failure but also some
details about the data block location too?

And if you really need to know "issuing migration failed" then why not
just add the string to the existing log message?

Alasdair
