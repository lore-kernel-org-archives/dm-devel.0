From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: Re: Question about dm target size
Date: Wed, 12 Nov 2014 12:15:16 +0100
Message-ID: <54634144.6080004@redhat.com>
References: <5462ABD8.1050609@fb.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <5462ABD8.1050609@fb.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids


On 11/12/2014 01:37 AM, Josef Bacik wrote:
> Hello,
>
> I'm creating a dm target to better test power fail situations and I'm 
> having trouble figuring out how to make the dm device appear as a 
> different size.  So for example you do the normal dm table
>
> offset size power-fail /dev/whatever args
>
> I want to use the entire size of /dev/whatever, but I want my dm 
> device to show up as size/2.  So right now I'm doing this in my ->ctr 
> function
>
> ti->len /= 2;

Passing in "ti->len = 'size of your dev in sectors' / 2" is what you want.

Heinz

>
> Is that acceptable, or will this have some side-effect that's going to 
> bite me in the ass?  I can't see any other target that does something 
> similar and there appears to be no helper function.  This seems to 
> work as far as blockdev --getsz is concerned, but I'm worried I need 
> to do more.  Thanks,
>
> Josef
>
> -- 
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
