From: "Kevin Foote" <kevin.foote@gmail.com>
Subject: Re: online disk resizing
Date: Thu, 5 Jul 2007 10:26:59 -0400
Message-ID: <5fb0f77b0707050726t11063bd6u5c12229927e6fc0b@mail.gmail.com>
References: <E43E8EC1853DF64D8DF70C7FDC14E92A027093C5@dewdfe26.wdf.sap.corp>
	<468CE787.6040500@sigmatrans.ru>
	<7531FC6D348A2F4A9670BBC9BCB3250802B3E2E8@cm050024.europede.psinet.dc>
	<468CFB57.4050508@sigmatrans.ru>
	<7531FC6D348A2F4A9670BBC9BCB3250802B3E2EC@cm050024.europede.psinet.dc>
	<468CFDFC.7000807@sigmatrans.ru>
	<7531FC6D348A2F4A9670BBC9BCB3250802B3E2ED@cm050024.europede.psinet.dc>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1420412070=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <7531FC6D348A2F4A9670BBC9BCB3250802B3E2ED@cm050024.europede.psinet.dc>
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

--===============1420412070==
Content-Type: multipart/alternative;
	boundary="----=_Part_127461_28523957.1183645619125"

------=_Part_127461_28523957.1183645619125
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Yes same here.. with IO still going dm does the failover just fine (using
the echo scsi "remove/add") but failing back with a larger size is where I
have seene issues. Although we have never lost data :-)

-- 
:wq!
kevin.foote


On 7/5/07, Roland Mieslinger <roland.mieslinger@interoute.com> wrote:
>
> > -----Original Message-----
> > From: dm-devel-bounces@redhat.com
> > [mailto:dm-devel-bounces@redhat.com] On Behalf Of Alexander Benaguev
> > Sent: Donnerstag, 5. Juli 2007 16:20
> > To: device-mapper development
> > Subject: Re: [dm-devel] online disk resizing
> >
> > Roland Mieslinger wrote:
> > > Did you get a error from blockdev command?
> > none
> > > Did you stop all I/O to the device?
> > I can't!=) it's not online resizing, if I should stoping io;(
>
> That's were i stuck too.
> You can do it without reboot, but I've found no way to do it online.
>
> Roland
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>

------=_Part_127461_28523957.1183645619125
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Yes same here.. with IO still going dm does the failover just fine (using the echo scsi &quot;remove/add&quot;) but failing back with a larger size is where I have seene issues. Although we have never lost data :-) &nbsp;  <br>
<br>-- <br>:wq!<br>kevin.foote<br><br><br><div><span class="gmail_quote">On 7/5/07, <b class="gmail_sendername">Roland Mieslinger</b> &lt;<a href="mailto:roland.mieslinger@interoute.com">roland.mieslinger@interoute.com</a>
&gt; wrote:</span><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">&gt; -----Original Message-----<br>&gt; From: <a href="mailto:dm-devel-bounces@redhat.com">
dm-devel-bounces@redhat.com</a><br>&gt; [mailto:<a href="mailto:dm-devel-bounces@redhat.com">dm-devel-bounces@redhat.com</a>] On Behalf Of Alexander Benaguev<br>&gt; Sent: Donnerstag, 5. Juli 2007 16:20<br>&gt; To: device-mapper development
<br>&gt; Subject: Re: [dm-devel] online disk resizing<br>&gt;<br>&gt; Roland Mieslinger wrote:<br>&gt; &gt; Did you get a error from blockdev command?<br>&gt; none<br>&gt; &gt; Did you stop all I/O to the device?<br>&gt; I can&#39;t!=) it&#39;s not online resizing, if I should stoping io;(
<br><br>That&#39;s were i stuck too.<br>You can do it without reboot, but I&#39;ve found no way to do it online.<br><br>Roland<br><br>--<br>dm-devel mailing list<br><a href="mailto:dm-devel@redhat.com">dm-devel@redhat.com
</a><br><a href="https://www.redhat.com/mailman/listinfo/dm-devel">https://www.redhat.com/mailman/listinfo/dm-devel</a><br></blockquote></div><br><br clear="all"><br>

------=_Part_127461_28523957.1183645619125--


--===============1420412070==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1420412070==--
