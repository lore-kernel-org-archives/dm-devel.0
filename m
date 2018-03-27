From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: Can we drop 'hardware_handler "1 alua"'?
Date: Tue, 27 Mar 2018 18:01:54 +0200
Message-ID: <820d30f4-40ad-5a32-3ea3-2a8b871a9f83@gmail.com>
References: <1522140989.13140.12.camel@suse.com>
	<20180327150952.GW3103@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180327150952.GW3103@octiron.msp.redhat.com>
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
To: Benjamin Marzinski <bmarzins@redhat.com>, Martin Wilck <mwilck@suse.com>
Cc: dm-devel mailing list <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 03/27/2018 05:09 PM, Benjamin Marzinski wrote:

> I do agree that any device
> that has *multiple modes* that it can be configured in (or at least
> devices that could be configured as ALUA or something else, where we
> can't tell from the vendor/product/revision) should have their default
> config set to the other mode, since multipath should autodetect if they
> are in alua mode.

They are only two of them: DGC and RDAC.

> If autodetection isn't working for some devices, we should fix that.

...if it can be done in multipath-tools/kernel, but if it's an array bug...
