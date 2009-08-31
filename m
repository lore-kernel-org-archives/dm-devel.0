From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: script to capture support data for Device mapper
	Multipath
Date: Mon, 31 Aug 2009 22:55:50 +0200
Message-ID: <1251752150.4672.5.camel@zezette>
References: <0D1E8821739E724A86F4D16902CE275C1C8EAE02A2@inbmail01.lsi.com>
Reply-To: christophe.varoqui@free.fr,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <0D1E8821739E724A86F4D16902CE275C1C8EAE02A2@inbmail01.lsi.com>
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
Cc: "Dachepalli, Sudhir" <Sudhir.Dachepalli@lsi.com>, "'dm-devel@redhat.com'" <dm-devel@redhat.com>, "Stankey,
	Robert" <Robert.Stankey@lsi.com>, "Moger, Babu" <Babu.Moger@lsi.com>
List-Id: dm-devel.ids

On lun., 2009-08-31 at 11:23 +0530, Chauhan, Vijay wrote:
> Hi Christophe and all, 
> 
> Attached is the script which captures Device Mapper Multipath support data. We have been using this script for capturing data and has been helpful in analysing dm related issues. These support data can be useful in analysing issues offline or remotely. Thought of posting it into this forum if it benefits everyone.  I still feel we can add something more. Waiting for your feedback.
> 
> In my opinion, as this script is meant to provide support to dm multipath it would be good if we can have this script as part multipath-tools. Please give your comment. 
> 
Vijay,

this script indeed grabs a lot of useful information, but 1/ people
wouldn't post that on a public mailing list 2/ distributors and
apparently some hardware vendors already have this kind of tools
(sosreport, ...)

So I'm not sure. Can distributors voice their opinion ?

Thanks anyway for posting your work.
cvaroqui
