From: =?ISO-8859-1?Q?Roger_H=E5kansson?= <hson@ludd.luth.se>
Subject: Re: Problems with multipathing
Date: Tue, 18 Apr 2006 07:04:49 +0200
Message-ID: <44447371.6060203@ludd.luth.se>
References: <443BF12E.50900@ludd.luth.se>	<443BF87A.10804@free.fr>	<443C19E6.8000607@ludd.luth.se>	<443E870E.1070902@ludd.luth.se>	<443EB907.1070600@free.fr>	<4442E2ED.7020405@ludd.luth.se>	<4443635F.5000401@free.fr>	<4443A390.5010005@ludd.luth.se>
	<44446F7E.2060502@free.fr>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <44446F7E.2060502@free.fr>
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

Christophe Varoqui wrote:
> ok.
> have you tried sending a START_STOP scsi command (wit sg_start from
> sg3_utils) to the affect'ed LUN instead of target-rescaning ?

No, but I'll try that.
I've noticed that you(?) have written something about that in the
"TestedEnvironments" section, but how does this "integrate" with
multipath-tools?

> I see your features still don't include "queue_if_no_path". You seem to
> really need it.

Yup, I've added that in my later tests and it seems to work as expected.
