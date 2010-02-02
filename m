From: Takahiro Yasui <tyasui@redhat.com>
Subject: Re: [PATCH] If all legs fail, return an error
Date: Tue, 02 Feb 2010 14:47:29 -0500
Message-ID: <4B688151.1070306@redhat.com>
References: <Pine.LNX.4.64.1001311530280.13480@hs20-bc2-1.build.redhat.com>
	<4B670EB6.5000201@redhat.com>
	<Pine.LNX.4.64.1002020755100.30625@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.1002021315140.30625@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.1002021315140.30625@hs20-bc2-1.build.redhat.com>
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
Cc: dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On 02/02/10 13:17, Mikulas Patocka wrote:
> BTW. if you want to follow this principle (abort bio if all legs fail), 
> you can also apply this patch, that does it for out-of-sync regions. It is 
> not critical, so it can wait for 2.6.34.

Looks good to me.

Reviewed-by: Takahiro Yasui <tyasui@redhat.com>

Thanks,
Taka
