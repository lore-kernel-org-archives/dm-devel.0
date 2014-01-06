From: Joe Thornber <thornber@redhat.com>
Subject: Re: [PATCH for-3.14 14/20] dm thin: requeue bios to DM
 core if no_free_space and in read-only mode
Date: Mon, 6 Jan 2014 14:38:45 +0000
Message-ID: <20140106143844.GH6766@debian>
References: <1387582653-13647-1-git-send-email-snitzer@redhat.com>
	<1387582653-13647-15-git-send-email-snitzer@redhat.com>
	<20140106143524.GG6766@debian>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20140106143524.GG6766@debian>
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

On Mon, Jan 06, 2014 at 02:35:24PM +0000, Joe Thornber wrote:
> Could we rename no_free_space please? (requeue_unserviceable_bios?)

Never mind, a later patch removes it completely.
