From: Dave Wysochanski <dave.wysochanski@redhat.com>
Subject: Re: patch to discovery.c to still get path priority for
	paths with path state of PATH_DOWN
Date: Mon, 13 Nov 2006 15:04:32 -0500
Message-ID: <1163448272.5006.48.camel@linux-cxyg.rtp.netapp.com>
References: <6CCEAEDF4D06984A83F427424F47D6E4013D1535@CORPUSMX40A.corp.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <6CCEAEDF4D06984A83F427424F47D6E4013D1535@CORPUSMX40A.corp.emc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: christophe.varoqui@free.fr
List-Id: dm-devel.ids

Ed, I am looking through your patches and in particular this change,
which reverts a previous change I submitted a little while back.

Maybe we can do something better like clarify states.  Looking through
the code now and will have more feedback.



On Fri, 2006-11-10 at 18:01 -0500, Edward Goggin wrote:
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
