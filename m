From: Muneendra Kumar M <mmandala@Brocade.com>
Subject: Re: unable to send mails to
 christophe.varoqui@opensvc.com using git
Date: Fri, 3 Feb 2017 19:18:25 +0000
Message-ID: <7197a46b9eb64c1e963687d50bb6e346@BRMWP-EXMB12.corp.brocade.com>
References: <2d3265b9e6094cb2a3807d7c248c0c1b@BRMWP-EXMB12.corp.brocade.com>
	<20170203155156.GI22981@octiron.msp.redhat.com>
	<28ddb8f82cb84549ae9058ebca9dac54@BRMWP-EXMB12.corp.brocade.com>
	<20170203181710.GK22981@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi Ben,
Can I send the patch and the cover letter  as inline through outlook instea=
d of sending it through git send-email ?
As iam still trying to figure out the issue.

Regads,
Muneendra.


-----Original Message-----
From: Muneendra Kumar M =

Sent: Friday, February 03, 2017 11:55 PM
To: 'Benjamin Marzinski' <bmarzins@redhat.com>
Cc: dm-devel@redhat.com
Subject: RE: [dm-devel] unable to send mails to christophe.varoqui@opensvc.=
com using git

Hi Ben,
Is there a way where we can check whether the patch has been sent to christ=
ophe.varoqui@opensvc.com.

Like how we see in  dm-devel list.

Regards,
Muneendra.

-----Original Message-----
From: Benjamin Marzinski [mailto:bmarzins@redhat.com]
Sent: Friday, February 03, 2017 11:47 PM
To: Muneendra Kumar M <mmandala@Brocade.com>
Cc: dm-devel@redhat.com
Subject: Re: [dm-devel] unable to send mails to christophe.varoqui@opensvc.=
com using git

On Fri, Feb 03, 2017 at 04:31:12PM +0000, Muneendra Kumar M wrote:
> Hi Ben,
> Thanks for the reply.
> But how do I make sure that my mail has successfully sent to the group.
> Whenever I sent the mail to my gmail account iam able to receive the patc=
h.

Your patch is on the list.  I'm not sure about why you can't send a mail to=
 Christophe.

-Ben
 =

> Regards,
> Muneendra.
> =

> -----Original Message-----
> From: Benjamin Marzinski [mailto:bmarzins@redhat.com]
> Sent: Friday, February 03, 2017 9:22 PM
> To: Muneendra Kumar M <mmandala@Brocade.com>
> Cc: dm-devel@redhat.com
> Subject: Re: [dm-devel] unable to send mails to =

> christophe.varoqui@opensvc.com using git
> =

> On Fri, Feb 03, 2017 at 09:58:52AM +0000, Muneendra Kumar M wrote:
> >    Hi ,
> > =

> >    Iam sending the patch to the community using the below command
> > =

> >    =A0
> > =

> >    # git send-email --to "device-mapper development <dm-devel@redhat.co=
m>"
> >    --cc "Christophe Varoqui <christophe.varoqui@opensvc.com>"
> >    --no-chain-reply-to --suppress-from <dir>
> > =

> >    =A0
> > =

> >    But iam getting the below error.Can anyone help me what could be the
> >    issue.
> =

> =

> If you don't have sendmail, postfix, etc. set up to send mail directly fr=
om your machine, I believe that you can just select a local mail server by =
adding the "--smtp-server=3D<host>" to your git send-email command, along w=
ith any other necessary "--smtp-*" options to use the server.
> =

> -Ben
> =

> > =

> >    =A0
> > =

> >    This is a MIME-encapsulated message.
> > =

> >    =A0
> > =

> >    --82D12C7A87CC.1486115491/localhost.localdomain
> > =

> >    Content-Description: Notification
> > =

> >    Content-Type: text/plain; charset=3Dus-ascii
> > =

> >    =A0
> > =

> >    This is the mail system at host localhost.localdomain.
> > =

> >    =A0
> > =

> >    I'm sorry to have to inform you that your message could not
> > =

> >    be delivered to one or more recipients. It's attached below.
> > =

> >    =A0
> > =

> >    For further assistance, please send mail to postmaster.
> > =

> >    =A0
> > =

> >    If you do so, please include this problem report. You can
> > =

> >    delete your own text from the attached returned message.
> > =

> >    =A0
> > =

> >    =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 The mail syst=
em
> > =

> >    =A0
> > =

> >    <christophe.varoqui@opensvc.com>: host spool.mail.gandi.net[217.70.1=
84.6]
> >    said:
> > =

> >    =A0=A0=A0 550 5.1.8 <root@localhost.localdomain>: Sender address rej=
ected:
> >    Domain not
> > =

> >    =A0 =A0=A0found (in reply to RCPT TO command)
> > =

> >    =A0
> > =

> >    --82D12C7A87CC.1486115491/localhost.localdomain
> > =

> >    Content-Description: Delivery report
> > =

> >    Content-Type: message/delivery-status
> > =

> >    =A0
> > =

> >    Reporting-MTA: dns; localhost.localdomain
> > =

> >    X-Postfix-Queue-ID: 82D12C7A87CC
> > =

> >    X-Postfix-Sender: rfc822; root@localhost.localdomain
> > =

> >    Arrival-Date: Fri,=A0 3 Feb 2017 15:20:59 +0530 (IST)
> > =

> >    =A0
> > =

> >    Final-Recipient: rfc822; christophe.varoqui@opensvc.com
> > =

> >    Action: failed
> > =

> >    Status: 5.1.8
> > =

> >    Remote-MTA: dns; spool.mail.gandi.net
> > =

> >    Diagnostic-Code: smtp; 550 5.1.8 <root@localhost.localdomain>: Sender
> >    address
> > =

> >    =A0=A0=A0 rejected: Domain not found
> > =

> >    =A0
> > =

> >    --82D12C7A87CC.1486115491/localhost.localdomain
> > =

> >    Content-Description: Undelivered Message
> > =

> >    Content-Type: message/rfc822
> > =

> >    =A0
> > =

> >    Return-Path: <root@localhost.localdomain>
> > =

> >    Received: by localhost.localdomain (Postfix, from userid 0)
> > =

> >    =A0=A0=A0=A0=A0=A0=A0 id 82D12C7A87CC; Fri,=A0 3 Feb 2017 15:20:59 +=
0530 (IST)
> > =

> >    From: M Muneendra Kumar <mmandala@brocade.com>
> > =

> >    To: device-mapper development <dm-devel@redhat.com>
> > =

> >    Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> > =

> >    Subject: [PATCH 0/1] multipathd: deterministic io throughput in =

> > multipath
> > =

> >    Date: Fri,=A0 3 Feb 2017 15:20:58 +0530
> > =

> >    Message-Id: =

> > <1486115459-13377-1-git-send-email-mmandala@brocade.com>
> > =

> >    X-Mailer: git-send-email 1.8.3.1
> > =

> >    =A0
> > =

> >    This patch adds three configuration parameters, =

> > "san_path_err_threshold",
> > =

> >    "san_path_err_recovery_time" and "san_path_err_forget_rate".
> > =

> >    =A0
> > =

> >    =A0
> > =

> >    Regards,
> >    Muneendra.
> =

> > --
> > dm-devel mailing list
> > dm-devel@redhat.com
> > https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__www.redhat.com_
> > ma
> > ilman_listinfo_dm-2Ddevel&d=3DDwIDAw&c=3DIL_XqQWOjubgfqINi2jTzg&r=3DE3f=
tc4
> > 7B6BGtZ4fVaYvkuv19wKvC_Mc6nhXaA1sBIP0&m=3DfgwQ0ID7x_eMdI37c1x7B9iVu9ow
> > KSfwEUBw6CwkKys&s=3DoLRQczdQfeAaDQebrx2azulbzM53hJW56HWAEhVrdIk&e=3D
