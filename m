From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: RE: [PATCH 0/6] scsi_dh : Couple of fixes for scsi device handlers
Date: Thu, 29 Jul 2010 17:04:36 -0700
Message-ID: <1280448276.17620.80.camel@chandra-lucid.beaverton.ibm.com>
References: <E463DF2B2E584B4A82673F53D62C2EF4D05DC420@cosmail01.lsi.com>
	 <1280440444.17620.72.camel@chandra-lucid.beaverton.ibm.com>
	 <E463DF2B2E584B4A82673F53D62C2EF4D0663845@cosmail01.lsi.com>
Reply-To: sekharan@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <E463DF2B2E584B4A82673F53D62C2EF4D0663845@cosmail01.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
To: "Moger, Babu" <Babu.Moger@lsi.com>
Cc: device-mapper development <dm-devel@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Shyam_Iyer@Dell.com" <Shyam_Iyer@Dell.com>, "Qi, Yanling" <Yanling.Qi@lsi.com>, "Chauhan, Vijay" <Vijay.Chauhan@lsi.com>, "Dachepalli, Sudhir" <Sudhir.Dachepalli@lsi.com>, "Stankey, Robert" <Robert.Stankey@lsi.com>
List-Id: dm-devel.ids

See comment below

On Thu, 2010-07-29 at 16:35 -0600, Moger, Babu wrote:
> Chandra, Shyam,  
>  Thanks for your comments.. Please see my response.
> 
> > -----Original Message-----
> > From: Chandra Seetharaman [mailto:sekharan@us.ibm.com]
> > Sent: Thursday, July 29, 2010 4:54 PM
> > To: Moger, Babu
> > Cc: device-mapper development; linux-scsi@vger.kernel.org; Qi, Yanling;
> > Chauhan, Vijay; Dachepalli, Sudhir; Stankey, Robert
> > Subject: Re: [PATCH 0/6] scsi_dh : Couple of fixes for scsi device
> > handlers
> > 
> > Babu,
> > 
> > Your main object is to protect scsi_dh_data across scsi_dh_activate()
> > by
> > way of getting kref around scsi_dh_activate(), right ?
> > 
> 
>   Yes, That is correct. 
> 
> > Wouldn't doing what Shyam suggested (doing kref_put() and put_device())
> > in scsi_activate() make it simpler and code still be readable ? (it
> > would make all the patches except 2/6 not needed).
> > 
> > Did you hit with any problems doing it that way ?
> >
> 
>   Yes, We can do that.  Problem is I am hitting the issue with BUG_ON
>  in get_rdac_data which is there in the beginning of rdac_activate.

I do not understand the problem.

If the BUG_ON on get_rdac_data() is being triggered, that means
sdev->scsi_dh_data is NULL, if that is the case, how can you access
sdev->scsi_dh_data->kref in scsi_dh_activate (in patch 2/6) ? Wouldn't
it trip a oops ?


>   If I have to go this way, then I need to remove a call get_rdac_data
>  and just validate pointers. Report error(SCSI_DH_IO) if pointer is not valid.
>   Then hold the reference counts and continue if everything is alright.
>   I will send the new patches as soon as I can.  


