From: Milan Broz <gmazyland@gmail.com>
Subject: Re: [PATCH 9/9] dm crypt: sort writes
Date: Tue, 01 Apr 2014 19:35:28 +0200
Message-ID: <533AF8E0.2040907@gmail.com>
References: <1396037476-26595-1-git-send-email-snitzer@redhat.com>	<1396037476-26595-10-git-send-email-snitzer@redhat.com>	<53368043.5000808@gmail.com>
	<20140331123940.GB25683@redhat.com>	<20140401083755.55afa738d5a98b6bc07aca71@valinux.co.jp>
	<20140401010129.GB9214@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20140401010129.GB9214@redhat.com>
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

On 04/01/2014 03:01 AM, Mike Snitzer wrote:
> OK.  FYI, I cleaned the code up a little today based on Milan's dislike
> for the #define within the function, see:
> https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=for-next&id=039e943277604c3f4f6b4ee803b8793627d53d36

Thanks.

Btw if you don't like sysfs option for disabling this, it can be optional table parameter,
there is already discard support implemented this way.

(I could add this myself later... just need to find at least few hours
of free time:)

Milan
