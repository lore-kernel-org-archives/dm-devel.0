From: Stephan =?UTF-8?Q?Austerm=C3=BChle?= <au@hcsd.de>
Subject: Re: CLARiiON failover modes and DM.
Date: Tue, 20 Nov 2007 12:20:43 +0100 (CET)
Message-ID: <58049.155.56.68.220.1195557643.squirrel@www.hcsd.de>
References: <940B4FF1F5958E4F96FC83C055A2F2611B8C5F@exch-2003.incipient.waltham>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <940B4FF1F5958E4F96FC83C055A2F2611B8C5F@exch-2003.incipient.waltham>
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

Hi Paul,

> Is there a specific failover mode that the CX must be set for DM
> interoperability?

We are using the defaults:

Initiator Type: 3 (Clariion Open)
Array Comm Path: 1 (enabled)
Failover Mode: 1
Unit Serial Number: Array

These settings work reliably for some hundred Linux servers and about two
years.

Kind regards,

Stephan
