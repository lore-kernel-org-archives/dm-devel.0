From: Leonardo Santos <heiligerstein@gmail.com>
Subject: Re: DM-Cache Writeback & Direct IO?
Date: Wed, 8 Jul 2015 14:55:05 -0300
Message-ID: <CAEZ+n-hF2EUPAHYC98ao0x_Q2nWXFodaxXkBqjg8ZvpqNviVKQ@mail.gmail.com>
References: <9E0DEE10BA62134F89BB5A513CA84BC3A1A6B5CA@MAILSERVER01.trt9a.local>
	<CAEZ+n-j_9QGWi7pdZY71VAmF-tnuRWb_8neWBd3iKMTm-yQU1A@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8368242170858008670=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAEZ+n-j_9QGWi7pdZY71VAmF-tnuRWb_8neWBd3iKMTm-yQU1A@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, evilazrael@evilazrael.de
List-Id: dm-devel.ids

--===============8368242170858008670==
Content-Type: multipart/alternative; boundary=001a113d5650c22a8f051a60d6cf

--001a113d5650c22a8f051a60d6cf
Content-Type: text/plain; charset=UTF-8

Are you using sequential or random workload?

It's important, since DMCache bypasses sequential I/O based on theshold.

--001a113d5650c22a8f051a60d6cf
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_extra"><div class=3D"gmail_quote"><pre=
 style=3D"color:rgb(0,0,0)"><font face=3D"arial, sans-serif">Are you using =
sequential or random workload?=C2=A0</font></pre><pre style=3D"color:rgb(0,=
0,0)"><span style=3D"font-family:arial,sans-serif">It&#39;s important, sinc=
e DMCache bypasses sequential I/O based on theshold.</span></pre></div></di=
v></div>

--001a113d5650c22a8f051a60d6cf--


--===============8368242170858008670==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============8368242170858008670==--
