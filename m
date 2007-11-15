From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: Multipath blacklist exceptions issues
Date: Thu, 15 Nov 2007 11:29:33 -0500 (EST)
Message-ID: <20071115.112933.41630475.k-ueda@ct.jp.nec.com>
References: <5201e28f0711141411ue475f31qc4db61076479bd7e@mail.gmail.com>
	<20071114.182842.97297202.k-ueda@ct.jp.nec.com>
	<5201e28f0711150707p18c8d1f8i39fb2ad26e955d65@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <5201e28f0711150707p18c8d1f8i39fb2ad26e955d65@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Stefan.Bader@de.ibm.com
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi Stefan,

On Thu, 15 Nov 2007 16:07:35 +0100, "Stefan Bader" <Stefan.Bader@de.ibm.com> wrote:
> > > > Before discussing details, I would like to make my standpoint clear.
> > > >   - Minimize the number of sections user has to modify as possible
> > > >   - Don't confuse users by pretending too much flexibility
> > > >
> > > > If we could do with only one section, it would be ideal.
> > > > However, wwid can be obtained only by getuid callout, which has
> > > > side effects of accessing devices and yielding unpleasant kernel
> > > > warning messages, etc.
> > > > So the filtering has to be splitted into 2 stages at least:
> > > >   before running getuid callout and after that
> > > > and we can't use wwid in the 1st stage.
> > > > Not to pretend that mixing wwid filtering and others is possible,
> > > > it's natural to have 2 different filtering sections.
> > >
> > >
> > > The behavior that is not that well expected is that if you can not do
> > > the following:
> > >
> > > blacklist {
> > >     devnode ".*"
> > >     wwid ".*"
> > > }
> > > blacklist_execptions {
> > >     devnode "^sda[0-9+]"
> > >     wwid "foo"
> > > }
> >
> > Sorry, I don't understand what you mean.  Could you elaborate that?
> > Do you mean that my proposal doesn't work for the case above?
> > Or do you mean that current code doesn't work as expected although
> > we can specify like above, but my proposal removes the confusion?
> 
> 
> I am sorry, I was a bit unclear. The example was for the current code, which
> allows to write a blacklist like in the example but does not give the
> expected result. Your proposal would (in my opinion) remove the confusion
> because both stages would apply the rules in the order they are written.
> Which is not the case in the current code.
> 
> In the current code there are, from my point of view, two problems:
> 1. the rules are not checked in the order they are written but in the order
> devnode, wwid, device.
> 2. the first match in the order above is used. There is no way to change
> this. For example (current code):
> 
> blacklist {
>     devnode ".*"
> }
> blacklist_exception {
>     wwid "foo"
>     devnode "dasda"
> }
> 
> This will only use dasda. The wwid entries are just useless.

Thank you for the detailed explanation.
I understand that you agree with my proposal.

Thanks,
Kiyoshi Ueda
