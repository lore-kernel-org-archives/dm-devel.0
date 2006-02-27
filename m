From: "Bruen, Mark" <mbruen@trilegiant.com>
Subject: Re: sd devices with 4 letters (i.e.: sdaa, sdab,	etc...)
	are not recognized
Date: Mon, 27 Feb 2006 13:48:22 -0500
Message-ID: <44034976.20405@trilegiant.com>
References: <4403471D.5060303@trilegiant.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4403471D.5060303@trilegiant.com>
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

Thanks but I figured it out, my blacklist was causing it.
    -Mark

Bruen, Mark wrote:

> I'm running device mapper on RHEL4 AMD64, luns which are mapped to 4 
> letter names (/dev/sdaa, /dev/sdab, etc...) are not seen by DM. I'm 
> sure it's a regex somewhere. ?
> Thanks.
>    -Mark
>
> -- 
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
