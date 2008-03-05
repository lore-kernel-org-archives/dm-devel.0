From: corbet@lwn.net (Jonathan Corbet)
Subject: Re: [RFC] An alternative interface to device mapper
Date: Wed, 05 Mar 2008 09:39:59 -0700
Message-ID: <22778.1204735199@vena.lwn.net>
References: <200803050129.43172.phillips@phunq.net>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1758093AbYCEQkP@vger.kernel.org>
In-reply-to: Your message of "Wed, 05 Mar 2008 01:29:42 PST."
             <200803050129.43172.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: Daniel Phillips <phillips@phunq.net>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Hey, Daniel,

> In more detail: ddlink is a generic pipe-like interface for controlling 
> device drivers.

I'm not in a position to say much about the wider picture at the moment,
but one quibble comes immediately to mind: why do you create yet another
communication path into the kernel rather than using netlink, which is
already there and used in a number of other contexts?

jon
