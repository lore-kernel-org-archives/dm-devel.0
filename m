From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [RFC] New  Logging approach for Device Mapper
Date: Sun, 6 Sep 2009 00:33:31 +0100
Message-ID: <20090905233331.GB2518@agk-dp.fab.redhat.com>
References: <0D1E8821739E724A86F4D16902CE275C1C8EAE093B@inbmail01.lsi.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <0D1E8821739E724A86F4D16902CE275C1C8EAE093B@inbmail01.lsi.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Chauhan, Vijay" <Vijay.Chauhan@lsi.com>
Cc: "Stankey, Robert" <Robert.Stankey@lsi.com>, "sekharan@linux.vnet.ibm.com" <sekharan@linux.vnet.ibm.com>, "Dachepalli, Sudhir" <Sudhir.Dachepalli@lsi.com>, "'dm-devel@redhat.com'" <dm-devel@redhat.com>, "agk@redhat.com" <agk@redhat.com>, "Moger, Babu" <Babu.Moger@lsi.com>
List-Id: dm-devel.ids

On Sun, Sep 06, 2009 at 12:36:02AM +0530, Chauhan, Vijay wrote:
> Each logging type is represented with 2 bits in dm_logging_level. Following are the logging types currently defined :

Does that mean there's a limit we'll soon exceed?

> Sep  5 18:32:02 localhost kernel: device-mapper: core: DEBUG: dm_resume: Unsetting DMF_SUSPENDED flag for 253:1

I was hoping the next extension to the macro code would somehow add info
like '253:1' (and maybe corresponding device name) automatically to
every message related to a device.


But do we really need this level of runtime debugging configurability?
I can't say I've come across problems where I'd have needed it: Can 
anyone else offer examples where it would have helped them?

Alasdair
