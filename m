From: "Stefan Bader" <Stefan.Bader@de.ibm.com>
Subject: Re: Question about work queues
Date: Fri, 16 Nov 2007 21:15:09 +0100
Message-ID: <5201e28f0711161215v56fb574cte46db56dbf748b8d@mail.gmail.com>
References: <D44F48C7D79D2943A073C8FA0F49A3CC0194E46D@orsmsx418.amr.corp.intel.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2012991149=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <D44F48C7D79D2943A073C8FA0F49A3CC0194E46D@orsmsx418.amr.corp.intel.com>
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

--===============2012991149==
Content-Type: multipart/alternative;
	boundary="----=_Part_11322_760249.1195244109320"

------=_Part_11322_760249.1195244109320
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi Brian,

not sure this solves the problem but:

2007/11/16, Wood, Brian J <brian.j.wood@intel.com>:
>
>
> static void trigger_event(struct work_struct *work);


This should be
static void trigger_event(void *data);

/* Initialize the work_struct */
> INIT_WORK(&sc->trigger_event, trigger_event);


INIT_WORK takes three arguments:

INIT_WORK(&sc->trigger_event, trigger_event,  xxx);

xxx is the pointer passed to the function call. Might probably be ti...


Regards,
Stefan

------=_Part_11322_760249.1195244109320
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi Brian,<br><br>not sure this solves the problem but:<br><br><div><span class="gmail_quote">2007/11/16, Wood, Brian J &lt;<a href="mailto:brian.j.wood@intel.com">brian.j.wood@intel.com</a>&gt;:</span><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
<br>static void trigger_event(struct work_struct *work);</blockquote><div><br>This should be<br>static void trigger_event(void *data);<br><br></div><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
/* Initialize the work_struct */<br> INIT_WORK(&amp;sc-&gt;trigger_event, trigger_event);</blockquote><div><br>INIT_WORK takes three arguments:<br><br>INIT_WORK(&amp;sc-&gt;trigger_event, trigger_event,&nbsp; xxx);<br><br>xxx is the pointer passed to the function call. Might probably be ti... 
<br></div></div><br><br>Regards,<br>Stefan<br>

------=_Part_11322_760249.1195244109320--


--===============2012991149==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2012991149==--
