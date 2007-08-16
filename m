From: "Ethan John" <ethan.john@gmail.com>
Subject: Re: Designing a new prio_callout
Date: Thu, 16 Aug 2007 10:30:28 -0700
Message-ID: <d61540a40708161030l794e57f0ub88b414aedc80b82@mail.gmail.com>
References: <d61540a40706211442w1ef3bacflddd44f74c8883a3f@mail.gmail.com>
	<d61540a40707290903q359cc7c8g52f07627b4b9fba7@mail.gmail.com>
	<46AD85A5.1060609@suse.de>
	<d61540a40708091055u725fa5e4wa182ac1d778323be@mail.gmail.com>
	<46BC7F14.80302@suse.de>
	<d61540a40708100840m541e198dg88c12d031febf968@mail.gmail.com>
	<d61540a40708141005n4eb06cebx14559f055b0df3d6@mail.gmail.com>
	<5201e28f0708150145s42ff46a5t8dab865931cb09d@mail.gmail.com>
	<d61540a40708150857v3182b221sa0c91d0cf90fd162@mail.gmail.com>
	<5201e28f0708160358h15124fb5u836b1700b8b823c7@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0544469674=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <5201e28f0708160358h15124fb5u836b1700b8b823c7@mail.gmail.com>
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

--===============0544469674==
Content-Type: multipart/alternative;
	boundary="----=_Part_5045_4209194.1187285428365"

------=_Part_5045_4209194.1187285428365
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

I don't think it's possible to get the IP of the iSCSI session from within
multipath. If anyone knows a way, I could easily write a dumb version of a
callout like you describe.

I'm not convinced, though, that I could do much better than prio_random with
rr_min_io > 2 billion without some extensive work. You'd have to re-check
path priorities for each call to the script, which would involve walking
through all existing paths and priorities and deciding on path priorities in
some intelligent way. It would get hairy pretty quickly.

Thanks for the tidbit on how round robin works. Great to know!

On 8/16/07, Stefan Bader <Stefan.Bader@de.ibm.com> wrote:
>
> > Now what happens? If mytarget has multiple LUs associated with it, the
> > multipath output will look like it did below if failover is being used
> --
> > two paths for each of two devices. The problem for us is that by
> default,
> > multipath just uses the first path that it sees. Which means that for
> every
> > device in mytarget, all data will be read and written across just the
> first
> > path -- 10.53.151.22, in this case.
> >
> > We need a way to load balance connections across all available
> connections.
> >
> > There are several ways that I can see to do this. Ideally, we would
> > implement ALUA on our end and advise people to use mpath_prio_alua as
> their
> > callout. But this has a development cost. We could also implement a
> custom
> > system as your suggest, but this also has a development cost.
> >
> > If we could advise users to manually set priorities on the client side,
> that
> > would be acceptable, but this is impossible with the current version of
> > multipath.
> >
>
> Can you find the IP address and UID of a device with the node name?
> For example you get /dev/sdc and then look for UID (can be retrieved
> with scsi_id) and the IP address of the connection (not sure this is
> possible). Then manually create a file containing mappings:
>
> <uid>:<ip>:<priority>
> ...
>
> Create a script that is used as the callout which takes a node name
> looks into the file and prints out the priority. This way the priority
> of a path does not change like it does with random priorities. The
> other path will only be used on failure and switched back as soon as
> the other one is back again (with failback immediate).
>
>
> > On a related note, I've read the reports of people experiencing higher
> > levels of performance with lower settings of rr_min_io, but it seems to
> me
> > that as rr_min_io gets smaller, the system becomes less like
> active/passive
> > MPIO and more like active/active MPIO, so users experiencing this
> > performance improvement would be better off using group_by_serial, so
> that
> > all paths are excitable simultaneously.
> >
>
> The setting of rr_min_io only matters if you have more than one path
> per path group. Otherwise  you only can use one path at a time and
> there is no round-robin. If you have more than one path in a group
> then lower values help since paths are more likely to be used
> concurrently. The default of 1000 is to high. Kiyoshi Ueda and
> Jun'ichi Nomura have done some measurements while looking for a way to
> improve performance more generally
> (https://ols2006.108.redhat.com/2007/Reprints/ueda-Reprint.pdf). But
> again, rr_min_io is only relevant to load-balance paths within the
> same path group (multibus or as you mentioned group_by_serial). The
> reason for you path changes (except for real failures) might be rather
> that random_prio results in different priorities whenever any priority
> value is checked again.
>
> Stefan
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>



-- 
Ethan John
http://www.flickr.com/photos/thaen/
(206) 841.4157

------=_Part_5045_4209194.1187285428365
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

I don&#39;t think it&#39;s possible to get the IP of the iSCSI session from within multipath. If anyone knows a way, I could easily write a dumb version of a callout like you describe.<br><br>I&#39;m not convinced, though, that I could do much better than prio_random with rr_min_io &gt; 2 billion without some extensive work. You&#39;d have to re-check path priorities for each call to the script, which would involve walking through all existing paths and priorities and deciding on path priorities in some intelligent way. It would get hairy pretty quickly. 
<br><br>Thanks for the tidbit on how round robin works. Great to know!<br><br><div><span class="gmail_quote">On 8/16/07, <b class="gmail_sendername">Stefan Bader</b> &lt;<a href="mailto:Stefan.Bader@de.ibm.com">Stefan.Bader@de.ibm.com
</a>&gt; wrote:</span><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">&gt; Now what happens? If mytarget has multiple LUs associated with it, the
<br>&gt; multipath output will look like it did below if failover is being used --<br>&gt; two paths for each of two devices. The problem for us is that by default,<br>&gt; multipath just uses the first path that it sees. Which means that for every
<br>&gt; device in mytarget, all data will be read and written across just the first<br>&gt; path -- <a href="http://10.53.151.22">10.53.151.22</a>, in this case.<br>&gt;<br>&gt; We need a way to load balance connections across all available connections.
<br>&gt;<br>&gt; There are several ways that I can see to do this. Ideally, we would<br>&gt; implement ALUA on our end and advise people to use mpath_prio_alua as their<br>&gt; callout. But this has a development cost. We could also implement a custom
<br>&gt; system as your suggest, but this also has a development cost.<br>&gt;<br>&gt; If we could advise users to manually set priorities on the client side, that<br>&gt; would be acceptable, but this is impossible with the current version of
<br>&gt; multipath.<br>&gt;<br><br>Can you find the IP address and UID of a device with the node name?<br>For example you get /dev/sdc and then look for UID (can be retrieved<br>with scsi_id) and the IP address of the connection (not sure this is
<br>possible). Then manually create a file containing mappings:<br><br>&lt;uid&gt;:&lt;ip&gt;:&lt;priority&gt;<br>...<br><br>Create a script that is used as the callout which takes a node name<br>looks into the file and prints out the priority. This way the priority
<br>of a path does not change like it does with random priorities. The<br>other path will only be used on failure and switched back as soon as<br>the other one is back again (with failback immediate).<br><br><br>&gt; On a related note, I&#39;ve read the reports of people experiencing higher
<br>&gt; levels of performance with lower settings of rr_min_io, but it seems to me<br>&gt; that as rr_min_io gets smaller, the system becomes less like active/passive<br>&gt; MPIO and more like active/active MPIO, so users experiencing this
<br>&gt; performance improvement would be better off using group_by_serial, so that<br>&gt; all paths are excitable simultaneously.<br>&gt;<br><br>The setting of rr_min_io only matters if you have more than one path<br>per path group. Otherwise&nbsp;&nbsp;you only can use one path at a time and
<br>there is no round-robin. If you have more than one path in a group<br>then lower values help since paths are more likely to be used<br>concurrently. The default of 1000 is to high. Kiyoshi Ueda and<br>Jun&#39;ichi Nomura have done some measurements while looking for a way to
<br>improve performance more generally<br>(<a href="https://ols2006.108.redhat.com/2007/Reprints/ueda-Reprint.pdf">https://ols2006.108.redhat.com/2007/Reprints/ueda-Reprint.pdf</a>). But<br>again, rr_min_io is only relevant to load-balance paths within the
<br>same path group (multibus or as you mentioned group_by_serial). The<br>reason for you path changes (except for real failures) might be rather<br>that random_prio results in different priorities whenever any priority<br>
value is checked again.<br><br>Stefan<br><br>--<br>dm-devel mailing list<br><a href="mailto:dm-devel@redhat.com">dm-devel@redhat.com</a><br><a href="https://www.redhat.com/mailman/listinfo/dm-devel">https://www.redhat.com/mailman/listinfo/dm-devel
</a><br></blockquote></div><br><br clear="all"><br>-- <br>Ethan John<br><a href="http://www.flickr.com/photos/thaen/">http://www.flickr.com/photos/thaen/</a><br>(206) 841.4157

------=_Part_5045_4209194.1187285428365--


--===============0544469674==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0544469674==--
