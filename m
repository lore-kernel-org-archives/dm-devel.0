From: Joe Thornber <thornber@redhat.com>
Subject: Re: dm-cache failure semantics in write-back mode
Date: Tue, 3 Mar 2015 17:28:12 +0000
Message-ID: <20150303172811.GB23166@debian>
References: <CAM2wQBtW2Bit2rx-1+hngUyh1gObtt+vjWQkDVWcTfm=axCyDw@mail.gmail.com>
	<CAM2wQBsGay5cnTR+CO_BpSL8SiYiaQm-MnWFDQC_hG1AH3PcQw@mail.gmail.com>
	<20150303161935.GA23166@debian>
	<CAM2wQBsS2hyA674CspKx6xZ49Fc1a=53UghaT5JkAPpjT3D_Ng@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CAM2wQBsS2hyA674CspKx6xZ49Fc1a=53UghaT5JkAPpjT3D_Ng@mail.gmail.com>
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
Cc: Thanos Makatos <thanos.makatos@onapp.com>, heinzm@redhat.com, snitzer@redhat.com
List-Id: dm-devel.ids

On Tue, Mar 03, 2015 at 05:13:37PM +0000, Thanos Makatos wrote:
> Thanks, Joe. So just to make sure I've understood correctly, if the SSD
> cache is configured as a write-back cache but the device cache is
> disabled/set to write-though on the HDD and the SSD, then there is no risk
> of data loss in the event of a failure. Is my understanding correct?

IO that has completed will have really hit the disk.
