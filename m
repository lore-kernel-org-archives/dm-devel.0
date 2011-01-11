From: Yakov Hrebtov <hrebtov@gmail.com>
Subject: Re: PROBLEM: SSD access time with dm-crypt is way too
 high
Date: Tue, 11 Jan 2011 17:07:01 +0500
Message-ID: <4D2C47E5.8020701@gmail.com>
References: <1294580107.2076.89.camel@vpcz1maverick>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1294580107.2076.89.camel@vpcz1maverick>
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
Cc: michaelzugelder@googlemail.com
List-Id: dm-devel.ids

09.01.2011 18:35, Michael Zugelder wrote:
> from kernel 2.6.33 on (at least up to 2.6.37) the access time when using
> dm-crypt on SSD is way too high. I would expect it to be a bit worse
> than directly accessing the device (~0.2ms here), but currently it's at
> exactly 10ms (except a few outlines). This corresponds to CONFIG_HZ=100.

I have similar problems, but 2.6.32 is also affected for me.
Look details here: https://bugzilla.kernel.org/show_bug.cgi?id=17892
