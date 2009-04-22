From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: RE: [PATCH] dm mpath: Try recover from I/O failure by
	re-initializing the PG if device is running on one path
Date: Wed, 22 Apr 2009 10:33:19 -0700
Message-ID: <1240421599.19442.8.camel@chandra-ubuntu>
References: <E463DF2B2E584B4A82673F53D62C2EF466A0E4DA@cosmail01.lsi.com>
	 <49ED1C24.9090303@ct.jp.nec.com>
	 <E463DF2B2E584B4A82673F53D62C2EF466A66DD4@cosmail01.lsi.com>
	 <49EE7870.3090008@ct.jp.nec.com>
	 <E463DF2B2E584B4A82673F53D62C2EF466A6707A@cosmail01.lsi.com>
Reply-To: sekharan@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <E463DF2B2E584B4A82673F53D62C2EF466A6707A@cosmail01.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
To: "Moger, Babu" <Babu.Moger@lsi.com>
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, "'dm-devel@redhat.com'" <dm-devel@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Chauhan, Vijay" <Vijay.Chauhan@lsi.com>
List-Id: dm-devel.ids

You mean to say that we do not require this patch/fix ?

On Wed, 2009-04-22 at 08:03 -0600, Moger, Babu wrote:
> Hi Kiyoshi,
> 
> > >>
> > >> Hi Babu,
> > >>
> > >> On 2009/04/21 3:05 +0900, Moger, Babu wrote:
> > >>> This patch introduces the mechanism to recover from I/O failures by
> > >>> re-initializing the path if the device is running on only one path.
> > >>>
> > >>> Problem: Device mapper fails the path for every I/O error. It does not
> > >>> care about the type of error. There are certain errors which can be
> > >>> recovered by re-initializing the path again. I have seen this problem
> > >>> during my testing on rdac device handler. I have observed I/O errors
> > >>> when there is a change in Lun ownership. When Lun ownership changes
> > >>> device will return back with check condition with
> > >>> sense 0x05/0x94/0x01(SK/ASC/ASCQ -meaning Lun ownership changed).
> > >>> Currently, device mapper fails the path for this error and eventually
> > >>> this will lead to I/O error. We don't want to see I/O error for this
> > >>> reason.
> > >>
> > >> Shouldn't we handle this type of device error inside device handler?
> > >
> > > The current error in question requires re-activation of the path.
> > > We already have a code to handle this scenario in device handler.
> > > But, the problem is the return status does not go to DM layer.
> > > The return status gets lost in scsi layer. For DM layer all the errors
> > > are -EIO. Any thoughts from your side.
> > 
> > Oh, I missed the point and I thought that re-activating the path
> > in your device handler was enough for the error.
> > Currently, I have no idea to handle your case only in dm without
> > seeing I/O error.
> > 
>   I have discussed about re-activating path in device handler with Chandra. Looks like that will lead to other issues (one is long boot up). Look like that is not an option.  
> > By the way, who did change the ownership when the device was running
> > with one path in your testing?  I can't see why such case happened.
> > 
> This can happen if the user knowingly or unknowingly changes the ownership. Also we have other feature in our storage which will allow user to redistribute the luns. Thanks for you comment.
> 
> > Thanks,
> > Kiyoshi Ueda
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

