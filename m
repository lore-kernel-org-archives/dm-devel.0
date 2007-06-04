From: "Wood, Brian J" <brian.j.wood@intel.com>
Subject: dmeventd - High level documentation,
	any kind of design documents
Date: Mon, 4 Jun 2007 09:21:25 -0700
Message-ID: <D44F48C7D79D2943A073C8FA0F49A3CCF796D8@orsmsx418.amr.corp.intel.com>
References: <4628E528.1070900@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <4628E528.1070900@ce.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hello, I was wondering if there were any kinds of design documents,
etc... types of notes on how the device mapper event daemon was
thought-up/designed? Or if anyone is working on documentation?=20

From what I've gathered so far (by reading the code) is that dmeventd is
designed around a plug-in type model (and that LVM has a plugin for this
that I could possibly trace through to see how this all works). Also,
I've dug in enough to see that error event handling and failure handling
for dmraid is not implemented (correct me if I'm wrong, please :) ) and
that there is some very simple event handling for LVM (just userspace
mirroring from what I've found)?

Ideally what I would like to help out with is developing a shared
library for the dmeventd daemon for dmraid so events could be reported
for the various raid levels. From what I understand Jonathan Brassow did
the initial work on dmeventd and might be my best resource in finding
implementation details. =20

Until I can put together a High-Level document that management can
understand about dmeventd's current functionality I'm sort of in a catch
22...I am being tasked with adding functionality to this project, but
can't start working until they know what is currently there and how it
was designed. Any help with guidance would be greatly appreciated.=20




Brian Wood
Intel Corporation=20
Digital Enterprise Group
Manageability & Platform Software Division
brian.j.wood@intel.com
