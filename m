From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Subject: Re: Constructing RAID 1+0 w/ LVM2/DM
Date: Thu, 24 Jan 2008 10:55:38 -0500
Message-ID: <4798B4FA.40108@hp.com>
References: <47989DA2.1070201@hp.com>	<20080124143540.GZ8075@agk.fab.redhat.com>	<4798A38E.2050206@hp.com>
	<20080124145428.GA8075@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20080124145428.GA8075@agk.fab.redhat.com>
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

Alasdair G Kergon wrote:
> On Thu, Jan 24, 2008 at 09:41:18AM -0500, Alan D. Brunelle wrote:
>   
>>            ignore_suspended_devices() && !device_is_usable(dev->dev)) {
>>     
>
> If you know what you're doing and using upstream kernels without dmeventd, drop
> the mirror test from device_is_usable().
>   

Thanks Alasdair!

> (Are all those corelogs just while testing?)
>   

Most assuredly so...

Alan

> Alasdair
>   
