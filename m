From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [RFC PATCH 2/2] dm-crypt: Use any key type which is registered
Date: Sat, 18 Jan 2020 09:55:26 -0800
Message-ID: <1579370126.3421.19.camel@HansenPartnership.com>
References: <1551456599-10603-1-git-send-email-franck.lenormand@nxp.com>
         <1551456599-10603-3-git-send-email-franck.lenormand@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1551456599-10603-3-git-send-email-franck.lenormand@nxp.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Franck LENORMAND <franck.lenormand@nxp.com>, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, keyrings@vger.kernel.org
Cc: horia.geanta@nxp.com, silvano.dininno@nxp.com, agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com, dhowells@redhat.com, jmorris@namei.org, serge@hallyn.com
List-Id: dm-devel.ids

On Fri, 2019-03-01 at 17:09 +0100, Franck LENORMAND wrote:
> @@ -2025,16 +2027,15 @@ static int crypt_set_keyring_key(struct
> crypt_config *cc, const char *key_string
>  	if (!key_desc || key_desc == key_string || !strlen(key_desc
> + 1))
>  		return -EINVAL;
>  
> -	if (strncmp(key_string, "logon:", key_desc - key_string + 1)
> &&
> -	    strncmp(key_string, "user:", key_desc - key_string + 1))
> -		return -EINVAL;
> +	type = get_key_type(key_string, key_desc - key_string);
> +	if (!type)
> +		return -ENOENT;

You can't do this.  This check ensures that the key responds correctly
to user_key_payload_locked() lower down.  To do that, the payload has
to be in a specific form.  You ensured that yours are, but dm-crypt
will now accept any key type, load the user payload blindly and create
all sorts of mayhem in the kernel because of the structural differences
in payload types.

James
