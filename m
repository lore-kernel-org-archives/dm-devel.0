From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: multipath-tools: broken build system + warnings
Date: Wed, 7 Mar 2018 23:30:59 +0100
Message-ID: <14bb2d20-3ace-909c-9c7c-99fc577dcc08@gmail.com>
References: <fd6979aa-f288-9752-ace3-b6472f600aa4@gmail.com>
	<1520457379.11340.21.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1520457379.11340.21.camel@suse.com>
Content-Language: en-GB
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>, Hannes Reinecke <hare@suse.de>, Bart Van Assche <Bart.VanAssche@wdc.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 03/07/2018 10:16 PM, Martin Wilck wrote:

> On Wed, 2018-03-07 at 17:40 +0100, Xose Vazquez Perez wrote:
>> Hi,
>>
>> It has to type "make" *twice* to build the full
>> source code.
> 
> Hm, strange. I need to double check. It doesn't happen with my tree
> AFAICS.
These are removed by "make":
rm random.o weightedpath.o ontap.o hp_sw.o hds.o sysfs.o rdac.o const.o datacore.o emc.o iet.o
rm tur.o emc_clariion.o hp_sw.o rdac.o readsector0.o cciss_tur.o
rm nvme.o
