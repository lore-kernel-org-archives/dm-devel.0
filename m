From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: unable to send mails to
 christophe.varoqui@opensvc.com using git
Date: Fri, 3 Feb 2017 09:51:56 -0600
Message-ID: <20170203155156.GI22981@octiron.msp.redhat.com>
References: <2d3265b9e6094cb2a3807d7c248c0c1b@BRMWP-EXMB12.corp.brocade.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <2d3265b9e6094cb2a3807d7c248c0c1b@BRMWP-EXMB12.corp.brocade.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Muneendra Kumar M <mmandala@Brocade.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Fri, Feb 03, 2017 at 09:58:52AM +0000, Muneendra Kumar M wrote:
>    Hi ,
> =

>    Iam sending the patch to the community using the below command
> =

>    =A0
> =

>    # git send-email --to "device-mapper development <dm-devel@redhat.com>"
>    --cc "Christophe Varoqui <christophe.varoqui@opensvc.com>"
>    --no-chain-reply-to --suppress-from <dir>
> =

>    =A0
> =

>    But iam getting the below error.Can anyone help me what could be the
>    issue.


If you don't have sendmail, postfix, etc. set up to send mail directly
from your machine, I believe that you can just select a local mail
server by adding the "--smtp-server=3D<host>" to your git send-email
command, along with any other necessary "--smtp-*" options to use the
server.

-Ben

> =

>    =A0
> =

>    This is a MIME-encapsulated message.
> =

>    =A0
> =

>    --82D12C7A87CC.1486115491/localhost.localdomain
> =

>    Content-Description: Notification
> =

>    Content-Type: text/plain; charset=3Dus-ascii
> =

>    =A0
> =

>    This is the mail system at host localhost.localdomain.
> =

>    =A0
> =

>    I'm sorry to have to inform you that your message could not
> =

>    be delivered to one or more recipients. It's attached below.
> =

>    =A0
> =

>    For further assistance, please send mail to postmaster.
> =

>    =A0
> =

>    If you do so, please include this problem report. You can
> =

>    delete your own text from the attached returned message.
> =

>    =A0
> =

>    =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 The mail system
> =

>    =A0
> =

>    <christophe.varoqui@opensvc.com>: host spool.mail.gandi.net[217.70.184=
.6]
>    said:
> =

>    =A0=A0=A0 550 5.1.8 <root@localhost.localdomain>: Sender address rejec=
ted:
>    Domain not
> =

>    =A0 =A0=A0found (in reply to RCPT TO command)
> =

>    =A0
> =

>    --82D12C7A87CC.1486115491/localhost.localdomain
> =

>    Content-Description: Delivery report
> =

>    Content-Type: message/delivery-status
> =

>    =A0
> =

>    Reporting-MTA: dns; localhost.localdomain
> =

>    X-Postfix-Queue-ID: 82D12C7A87CC
> =

>    X-Postfix-Sender: rfc822; root@localhost.localdomain
> =

>    Arrival-Date: Fri,=A0 3 Feb 2017 15:20:59 +0530 (IST)
> =

>    =A0
> =

>    Final-Recipient: rfc822; christophe.varoqui@opensvc.com
> =

>    Action: failed
> =

>    Status: 5.1.8
> =

>    Remote-MTA: dns; spool.mail.gandi.net
> =

>    Diagnostic-Code: smtp; 550 5.1.8 <root@localhost.localdomain>: Sender
>    address
> =

>    =A0=A0=A0 rejected: Domain not found
> =

>    =A0
> =

>    --82D12C7A87CC.1486115491/localhost.localdomain
> =

>    Content-Description: Undelivered Message
> =

>    Content-Type: message/rfc822
> =

>    =A0
> =

>    Return-Path: <root@localhost.localdomain>
> =

>    Received: by localhost.localdomain (Postfix, from userid 0)
> =

>    =A0=A0=A0=A0=A0=A0=A0 id 82D12C7A87CC; Fri,=A0 3 Feb 2017 15:20:59 +05=
30 (IST)
> =

>    From: M Muneendra Kumar <mmandala@brocade.com>
> =

>    To: device-mapper development <dm-devel@redhat.com>
> =

>    Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> =

>    Subject: [PATCH 0/1] multipathd: deterministic io throughput in multip=
ath
> =

>    Date: Fri,=A0 3 Feb 2017 15:20:58 +0530
> =

>    Message-Id: <1486115459-13377-1-git-send-email-mmandala@brocade.com>
> =

>    X-Mailer: git-send-email 1.8.3.1
> =

>    =A0
> =

>    This patch adds three configuration parameters, "san_path_err_threshol=
d",
> =

>    "san_path_err_recovery_time" and "san_path_err_forget_rate".
> =

>    =A0
> =

>    =A0
> =

>    Regards,
>    Muneendra.

> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
