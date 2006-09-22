From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: Why is device mapper unable to remove a mapped device
	which is open?
Date: Fri, 22 Sep 2006 21:43:12 +0100
Message-ID: <20060922204312.GY17654@agk.surrey.redhat.com>
References: <6CCEAEDF4D06984A83F427424F47D6E4013D13D9@CORPUSMX40A.corp.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <6CCEAEDF4D06984A83F427424F47D6E4013D13D9@CORPUSMX40A.corp.emc.com>
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
List-Id: dm-devel.ids

On Fri, Sep 22, 2006 at 04:26:16PM -0400, goggin, edward wrote:
> Why shouldn't the kernel's reference counting for the
> mapped device's md structure account for properly 
> handling the de-allocation of the md structure upon
> the last close in this case?

This behaviour has flipped a couple of times during the
development.

It would be fine if devices could never be suspended.
You can't close a suspended device you've written to
until it gets resumed.  If you've removed it you can't
resume it because it has gone.

It's similar in a way to how the kernel used to (at least I assume someone
fixed it?) let you unlink a swap file and then it was impossible to
'swapoff' because you couldn't reference the device any more.
 
Alasdair
-- 
agk@redhat.com
