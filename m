From: Javier Barroso <javibarroso@gmail.com>
Subject: Re: Removing a failed device from LVM2/DM
Date: Wed, 23 Sep 2009 06:59:04 +0200
Message-ID: <81c921f30909222159r1d27cee4vcd370043aae4b056@mail.gmail.com>
References: <1251731770.6817.31.camel@cail> <1251821775.5459.21.camel@cail>
	<20090901162537.GA15197@us.ibm.com> <1251830539.5459.135.camel@cail>
	<20090901190843.GA18641@us.ibm.com> <1251838679.5459.148.camel@cail>
	<20090901224704.GA23179@us.ibm.com> <1251989638.9319.1.camel@cail>
	<20090903151547.GA31143@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090903151547.GA31143@us.ibm.com>
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

On Thu, Sep 3, 2009 at 5:15 PM,  <malahal@us.ibm.com> wrote:
> Alan D. Brunelle [Alan.Brunelle@hp.com] wrote:
>> On Tue, 2009-09-01 at 15:47 -0700, malahal@us.ibm.com wrote:
>> > filter = [ "r|sdab|", a|/dev/sd|", "r|.*|" ]
>>
>> Other than adding in the missing " ("a|/dev/sd|") this seems to have
>> fixed the problem. Thanks!

But in the future, is it not possible host will reutilize "/dev/sdab"
to another device?

Is this change sure in nexts boots ?

Thank you
