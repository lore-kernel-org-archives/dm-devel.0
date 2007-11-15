From: "Stefan Bader" <Stefan.Bader@de.ibm.com>
Subject: Re: Multipath blacklist exceptions issues
Date: Thu, 15 Nov 2007 16:07:35 +0100
Message-ID: <5201e28f0711150707p18c8d1f8i39fb2ad26e955d65@mail.gmail.com>
References: <5201e28f0711131517p79fc4a8dk1da9bda922c3093e@mail.gmail.com>
	<20071114.154456.71084719.k-ueda@ct.jp.nec.com>
	<5201e28f0711141411ue475f31qc4db61076479bd7e@mail.gmail.com>
	<20071114.182842.97297202.k-ueda@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0787910581=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20071114.182842.97297202.k-ueda@ct.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============0787910581==
Content-Type: multipart/alternative;
	boundary="----=_Part_6296_12190767.1195139255874"

------=_Part_6296_12190767.1195139255874
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

2007/11/15, Kiyoshi Ueda <k-ueda@ct.jp.nec.com>:
>
> Hi Stefan,
>
> Did you drop dm-devel from Cc meaningly?


Oops, no. Just me accidentally using reply instead of reply-all

On Wed, 14 Nov 2007 23:11:55 +0100, "Stefan Bader" <sbader3@googlemail.com>
> wrote:
> > > Before discussing details, I would like to make my standpoint clear.
> > >   - Minimize the number of sections user has to modify as possible
> > >   - Don't confuse users by pretending too much flexibility
> > >
> > > If we could do with only one section, it would be ideal.
> > > However, wwid can be obtained only by getuid callout, which has
> > > side effects of accessing devices and yielding unpleasant kernel
> > > warning messages, etc.
> > > So the filtering has to be splitted into 2 stages at least:
> > >   before running getuid callout and after that
> > > and we can't use wwid in the 1st stage.
> > > Not to pretend that mixing wwid filtering and others is possible,
> > > it's natural to have 2 different filtering sections.
> >
> >
> > The behavior that is not that well expected is that if you can not do
> the
> > following:
> >
> > blacklist {
> >     devnode ".*"
> >     wwid ".*"
> > }
> > blacklist_execptions {
> >     devnode "^sda[0-9+]"
> >     wwid "foo"
> > }
>
> Sorry, I don't understand what you mean.  Could you elaborate that?
> Do you mean that my proposal doesn't work for the case above?
> Or do you mean that current code doesn't work as expected although
> we can specify like above, but my proposal removes the confusion?


I am sorry, I was a bit unclear. The example was for the current code, which
allows to write a blacklist like in the example but does not give the
expected result. Your proposal would (in my opinion) remove the confusion
because both stages would apply the rules in the order they are written.
Which is not the case in the current code.

In the current code there are, from my point of view, two problems:
1. the rules are not checked in the order they are written but in the order
devnode, wwid, device.
2. the first match in the order above is used. There is no way to change
this. For example (current code):

blacklist {
    devnode ".*"
}
blacklist_exception {
    wwid "foo"
    devnode "dasda"
}

This will only use dasda. The wwid entries are just useless.

Regards,
Stefan

------=_Part_6296_12190767.1195139255874
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<br><br><div><span class="gmail_quote">2007/11/15, Kiyoshi Ueda &lt;<a href="mailto:k-ueda@ct.jp.nec.com">k-ueda@ct.jp.nec.com</a>&gt;:</span><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
Hi Stefan,<br><br>Did you drop dm-devel from Cc meaningly?</blockquote><div><br>Oops, no. Just me accidentally using reply instead of reply-all<br></div><br><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
On Wed, 14 Nov 2007 23:11:55 +0100, &quot;Stefan Bader&quot; &lt;<a href="mailto:sbader3@googlemail.com">sbader3@googlemail.com</a>&gt; wrote:<br>&gt; &gt; Before discussing details, I would like to make my standpoint clear.
<br>&gt; &gt;&nbsp;&nbsp; - Minimize the number of sections user has to modify as possible<br>&gt; &gt;&nbsp;&nbsp; - Don&#39;t confuse users by pretending too much flexibility<br>&gt; &gt;<br>&gt; &gt; If we could do with only one section, it would be ideal.
<br>&gt; &gt; However, wwid can be obtained only by getuid callout, which has<br>&gt; &gt; side effects of accessing devices and yielding unpleasant kernel<br>&gt; &gt; warning messages, etc.<br>&gt; &gt; So the filtering has to be splitted into 2 stages at least:
<br>&gt; &gt;&nbsp;&nbsp; before running getuid callout and after that<br>&gt; &gt; and we can&#39;t use wwid in the 1st stage.<br>&gt; &gt; Not to pretend that mixing wwid filtering and others is possible,<br>&gt; &gt; it&#39;s natural to have 2 different filtering sections.
<br>&gt;<br>&gt;<br>&gt; The behavior that is not that well expected is that if you can not do the<br>&gt; following:<br>&gt;<br>&gt; blacklist {<br>&gt;&nbsp;&nbsp;&nbsp;&nbsp; devnode &quot;.*&quot;<br>&gt;&nbsp;&nbsp;&nbsp;&nbsp; wwid &quot;.*&quot;<br>&gt; }
<br>&gt; blacklist_execptions {<br>&gt;&nbsp;&nbsp;&nbsp;&nbsp; devnode &quot;^sda[0-9+]&quot;<br>&gt;&nbsp;&nbsp;&nbsp;&nbsp; wwid &quot;foo&quot;<br>&gt; }<br><br>Sorry, I don&#39;t understand what you mean.&nbsp;&nbsp;Could you elaborate that?<br>Do you mean that my proposal doesn&#39;t work for the case above?
<br>Or do you mean that current code doesn&#39;t work as expected although<br>we can specify like above, but my proposal removes the confusion?</blockquote><div><br>I am sorry, I was a bit unclear. The example was for the current code, which allows to write a blacklist like in the example but does not give the expected result. Your proposal would (in my opinion) remove the confusion because both stages would apply the rules in the order they are written. Which is not the case in the current code.
<br><br>In the current code there are, from my point of view, two problems:<br>1. the rules are not checked in the order they are written but in the order devnode, wwid, device.<br>2. the first match in the order above is used. There is no way to change this. For example (current code):
<br><br>blacklist {<br>&nbsp;&nbsp;&nbsp; devnode &quot;.*&quot;<br>}<br>blacklist_exception {<br>&nbsp;&nbsp;&nbsp; wwid &quot;foo&quot;<br>&nbsp;&nbsp;&nbsp; devnode &quot;dasda&quot;<br>}<br></div><br></div>This will only use dasda. The wwid entries are just useless.
<br><br>Regards,<br>Stefan

------=_Part_6296_12190767.1195139255874--


--===============0787910581==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0787910581==--
