From: "Seewer Philippe" <philippe.seewer@bfh.ch>
Subject: Re: [PATCH] User-configurable HDIO_GETGEO for dm volumes
Date: Fri, 17 Feb 2006 09:14:53 +0100
Message-ID: <43F585FD.8020802@bfh.ch>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932585AbWBQIPS@vger.kernel.org>
Content-class: urn:content-classes:message
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: "Darrick J. Wong" <djwong@us.ibm.com>, device-mapper development <dm-devel@redhat.com>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids


<snip>

Just on a side note: I'm currently working on a patch to make disk
geometry information available through sysfs (for all those devices that
provide getgeo) and and extended patch to make it writable through the
same interface by introducing a setgeo function as a companion to getgeo.

Perhaps this'll make some of this easier...
