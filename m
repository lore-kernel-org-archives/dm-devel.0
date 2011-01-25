From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: Announcement: new device-mapper thin provisioning
 target with infrastructure online for review
Date: Tue, 25 Jan 2011 15:07:00 -0500
Message-ID: <4D3F2D64.6060102@cfl.rr.com>
References: <1295972365.2936.77.camel@o>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1295972365.2936.77.camel@o>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: heinzm@redhat.com, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 1/25/2011 11:19 AM, Heinz Mauelshagen wrote:
> Using the thin provisioning target
> 
> Table line syntax (also see thinp_ctr() in dm-thin-prov.c):
> 
> <start> <len> thin-prov \
> <data_dev> <meta_dev> <data_block_size> <low_water_mark>
> 
> * data_dev: device holding thin provisioned data blocks
> * meta_dev: device keeping track of provisioned blocks
> * data_block_size: provisioning unit size in sectors
> * low_water_mark: block low water mark to throw a dm event
>   for userpace to resize

I assume that meta_dev can't, but can data_dev be shared between
multiple thin-prov targets?
