From: David Howells <dhowells@redhat.com>
Subject: Re: [RFC PATCH 0/2] Create CAAM HW key in linux keyring and use in dmcrypt
Date: Wed, 06 Mar 2019 17:29:55 +0000
Message-ID: <11177.1551893395@warthog.procyon.org.uk>
References: <1551456599-10603-1-git-send-email-franck.lenormand@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1551456599-10603-1-git-send-email-franck.lenormand@nxp.com>
Content-ID: <11176.1551893395.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Franck LENORMAND <franck.lenormand@nxp.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, keyrings@vger.kernel.org, horia.geanta@nxp.com, silvano.dininno@nxp.com, agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com, jmorris@namei.org, serge@hallyn.com
List-Id: dm-devel.ids

Franck LENORMAND <franck.lenormand@nxp.com> wrote:

> The capacity to generate or load keys already available in the Linux key
> retention service does not allows to exploit CAAM capabilities hence we
> need to create a new key_type. The new key type "caam_tk" allows to:
>  - Create a black key from random
>  - Create a black key from a red key
>  - Load a black blob to retrieve the black key

Is it possible that this could be done through an existing key type, such as
the asymmetric, trusted or encrypted key typed?

David
